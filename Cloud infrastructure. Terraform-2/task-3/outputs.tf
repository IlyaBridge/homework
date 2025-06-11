output "web_external_ip" {
  value = yandex_compute_instance.platform_web.network_interface.0.nat_ip_address
}

output "web_internal_ip" {
  value = yandex_compute_instance.platform_web.network_interface.0.ip_address
}

output "db_external_ip" {
  value = yandex_compute_instance.platform_db.network_interface.0.nat_ip_address
}

output "db_internal_ip" {
  value = yandex_compute_instance.platform_db.network_interface.0.ip_address
}