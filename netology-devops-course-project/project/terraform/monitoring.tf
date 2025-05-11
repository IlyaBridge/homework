# /home/ilya/project/terraform/monitoring.tf

# Ресурс виртуальной машины для сервера Zabbix
resource "yandex_compute_instance" "zabbix_server" {
  name        = "zabbix-server"
  platform_id = "standard-v3"
  zone        = "ru-central1-a" 

  # Параметры ресурсов ВМ
  resources {
    cores  = 2           # 2 vCPU
    memory = 4           # 4 ГБ RAM
    core_fraction = 20   # Гарантированная доля vCPU (20%)
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
    user-data = file("${path.module}/cloud-init.yml") # Файл cloud-init
    ssh-keys = "ilya:${var.ssh_public_key}" 
  }

  scheduling_policy {
    preemptible = true
  }
}
