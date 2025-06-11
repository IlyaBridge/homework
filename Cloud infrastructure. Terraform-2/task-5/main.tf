resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_subnet" "develop_db" {
  name           = "${var.vpc_name}-db"
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}

# Web VM
resource "yandex_compute_instance" "platform_web" {
  name        = local.vm_settings.web.name
  platform_id = local.vm_settings.web.platform_id
  zone        = local.vm_settings.web.zone
  
  resources {
    cores         = local.vm_settings.web.cores
    memory        = local.vm_settings.web.memory
    core_fraction = local.vm_settings.web.fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  
  scheduling_policy {
    preemptible = local.vm_settings.web.preemptible
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = local.vm_settings.web.nat
  }

  metadata = {
    serial-port-enable = local.vm_settings.web.serial_port
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}

# DB VM
resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_settings.db.name
  platform_id = local.vm_settings.db.platform_id
  zone        = local.vm_settings.db.zone
  
  resources {
    cores         = local.vm_settings.db.cores
    memory        = local.vm_settings.db.memory
    core_fraction = local.vm_settings.db.fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  
  scheduling_policy {
    preemptible = local.vm_settings.db.preemptible
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = local.vm_settings.db.nat
  }

  metadata = {
    serial-port-enable = local.vm_settings.db.serial_port
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}

# resource "yandex_vpc_network" "develop" {
#   name = var.vpc_name
# }
# resource "yandex_vpc_subnet" "develop" {
#   name           = var.vpc_name
#   zone           = var.default_zone
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = var.default_cidr
# }


# data "yandex_compute_image" "ubuntu" {
#   family = "ubuntu-2004-lts"
# }
# resource "yandex_compute_instance" "platform" {
#   name        = "netology-develop-platform-web"
#   platform_id = "standart-v4"
#   resources {
#     cores         = 1
#     memory        = 1
#     core_fraction = 5
#   }
#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu.image_id
#     }
#   }
#   scheduling_policy {
#     preemptible = true
#   }
#   network_interface {
#     subnet_id = yandex_vpc_subnet.develop.id
#     nat       = true
#   }

#   metadata = {
#     serial-port-enable = 1
#     ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
#   }

# }
