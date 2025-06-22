# Создаем 3 одинаковых диска по 1 Гб
resource "yandex_compute_disk" "storage_disks" {
  count = 3
  name  = "storage-disk-${count.index}"
  size  = 1 # 1 ГБ
  zone  = var.default_zone
}

# Создаем ВМ "storage" с динамическим подключением дисков
resource "yandex_compute_instance" "storage" {
  name     = "storage"
  hostname = "storage"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  # Динамическое подключение дополнительных дисков
  dynamic "secondary_disk" {
    for_each = { for idx, disk in yandex_compute_disk.storage_disks : idx => disk.id }
    content {
      disk_id = secondary_disk.value
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  }
}