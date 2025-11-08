# 0. Статический IP
resource "yandex_vpc_address" "static_ip" {
  name = "static-ip-public-vm"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

# 1. Создаем VPC
resource "yandex_vpc_network" "network" {
  name = "main-network"
}

# 2. Публичная подсеть
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# 3. NAT-инстанс
resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat        = true
  }
}

# 4. Виртуалка в публичной подсети (со статическим IP)
resource "yandex_compute_instance" "public-vm" {
  name        = "public-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fe32ig226dls6f9tj"
      type     = "network-hdd"
      size     = 15
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.public.id
    nat            = true
    nat_ip_address = yandex_vpc_address.static_ip.external_ipv4_address[0].address
  }

  metadata = {
    "ssh-keys" = "ubuntu:${file("/home/ilya/.ssh/k8s_yandex_cloud.pub")}"
  }
}

# 5. Приватная подсеть
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private-rt.id
}

# 6. Таблица маршрутизации
resource "yandex_vpc_route_table" "private-rt" {
  name       = "private-route-table"
  network_id = yandex_vpc_network.network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}

# 7. Виртуалка в приватной подсети
resource "yandex_compute_instance" "private-vm" {
  name        = "private-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fe32ig226dls6f9tj"
      type     = "network-hdd"
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }

  metadata = {
    "ssh-keys" = "ubuntu:${file("/home/ilya/.ssh/k8s_yandex_cloud.pub")}"
  }
}

# 8. Instance Group с LAMP
resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-instance-group"
  folder_id          = "b1grpedldfrumqsrjf62"
  service_account_id = "aje9g9qvt96oghtqh8lf" # ID из вашего сервисного ключа

  instance_template {
    platform_id = "standard-v3"

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit" # LAMP image
        type     = "network-hdd"
        size     = 15
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = true
    }

    metadata = {
      ssh-keys  = "ubuntu:${file("/home/ilya/.ssh/k8s_yandex_cloud.pub")}"
      user-data = <<-EOF
        #cloud-config
        packages:
          - apache2
          - mysql-server
          - php
          - php-mysql
          - libapache2-mod-php
        runcmd:
          - systemctl enable apache2
          - systemctl start apache2
          - echo "<?php phpinfo(); ?>" > /var/www/html/info.php
          - echo '<html><body><h1>Hello from LAMP!</h1><img src="https://storage.yandexcloud.net/ilya-08-11-2025/image.jpg" alt="Image from bucket" width="500"></body></html>' > /var/www/html/index.html
        EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    interval = 30
    timeout  = 5
    http_options {
      port = 80
      path = "/"
    }
  }
}