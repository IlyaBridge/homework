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
      preemptible = var.vm_web_preemptible
      nat         = var.vm_web_nat
    },
    db = {
      name        = local.vm_db_full_name
      platform_id = var.vm_db_platform_id
      zone        = var.vm_db_zone
      preemptible = var.vm_db_preemptible
      nat         = var.vm_db_nat
    }
  }
}