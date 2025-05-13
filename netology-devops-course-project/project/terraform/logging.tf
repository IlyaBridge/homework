resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 6
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8pfd17g205ujpmpb0a" # Ubuntu 24.04
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_a.id
    nat       = false
  }

  metadata = {
    user-data = file("${path.module}/cloud-init.yml")
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
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
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/cloud-init.yml")
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_vpc_security_group" "elk_sg" {
  name        = "elk-security-group"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    port           = 9200
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }
}