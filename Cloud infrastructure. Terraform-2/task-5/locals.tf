locals {
  # Формируем имена ВМ с использованием интерполяции
  vm_web_full_name = "${var.vpc_name}-${var.vm_web_name}-${var.default_zone}"
  vm_db_full_name  = "${var.vpc_name}-${var.vm_db_name}-${var.vm_db_zone}"
  
  # Полные настройки для ВМ
  vm_settings = {
    web = {
      name        = local.vm_web_full_name
      platform_id = var.vm_web_platform_id
      zone        = var.default_zone
      cores       = var.vm_web_cores
      memory      = var.vm_web_memory
      fraction    = var.vm_web_core_fraction
      preemptible = var.vm_web_preemptible
      nat         = var.vm_web_nat
      serial_port = var.vm_web_serial_port_enable
    },
    db = {
      name        = local.vm_db_full_name
      platform_id = var.vm_db_platform_id
      zone        = var.vm_db_zone
      cores       = var.vm_db_cores
      memory      = var.vm_db_memory
      fraction    = var.vm_db_core_fraction
      preemptible = var.vm_db_preemptible
      nat         = var.vm_db_nat
      serial_port = var.vm_db_serial_port_enable
    }
  }
}