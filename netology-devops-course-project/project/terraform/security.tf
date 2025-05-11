# /home/ilya/project/terraform/security.tf
resource "yandex_compute_instance" "bastion_host" {
  name        = "bastion-host"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8pfd17g205ujpmpb0a" # Ubuntu 24.04
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/cloud-init.yml")
    ssh-keys = "ilya:${var.ssh_public_key}" # SSH ключь из variables.tf
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_vpc_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["192.168.20.0/24", "192.168.30.0/24"] 
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "web_servers_sg" {
  name        = "web-servers-security-group"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
  
resource "yandex_vpc_security_group" "zabbix_sg" {
  name        = "zabbix-server-sg"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    port           = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 10051  # Для приёма данных от агентов
    v4_cidr_blocks = ["192.168.20.0/24", "192.168.30.0/24"] # Подсети с агентами
  }

  egress {
    protocol       = "TCP"
    port           = 10050  # Для инициации проверок сервером
    v4_cidr_blocks = ["192.168.20.0/24", "192.168.30.0/24"]
  }

  egress {
    protocol       = "TCP"
    port           = 10051 # Для активных проверок
    v4_cidr_blocks = ["192.168.20.0/24", "192.168.30.0/24"]
  }

  egress {
    protocol       = "UDP"
    port           = 53
    v4_cidr_blocks = ["0.0.0.0/0"] # Для DNS
  }
  
  # Разрешаем другие исходящие соединения (для обновлений и т.д.)
    egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}
