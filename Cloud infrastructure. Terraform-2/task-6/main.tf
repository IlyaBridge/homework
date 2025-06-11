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
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources.web.hdd_size
      type     = var.vms_resources.web.hdd_type
    }
  }
  
  scheduling_policy {
    preemptible = local.vm_settings.web.preemptible
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = local.vm_settings.web.nat
  }

  metadata = var.metadata
}

# DB VM
resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_settings.db.name
  platform_id = local.vm_settings.db.platform_id
  zone        = local.vm_settings.db.zone
  
  resources {
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources.db.hdd_size
      type     = var.vms_resources.db.hdd_type
    }
  }
  
  scheduling_policy {
    preemptible = local.vm_settings.db.preemptible
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = local.vm_settings.db.nat
  }

  metadata = var.metadata
}