# resource "yandex_compute_snapshot_schedule" "daily_backup" {
#   name = "daily-backup-schedule"
resource "yandex_compute_snapshot_schedule" "daily_backup" {
  name = "daily-backup-${formatdate("DDMMYYYY", timestamp())}"

  schedule_policy {
    expression = "0 1 * * *" # Ежедневно в 1:00
  }

  snapshot_count = 7 # Храним 7 последних снимков

  snapshot_spec {
    description = "Daily backup"
  }

  disk_ids = [
    yandex_compute_instance.web_server_a.boot_disk.0.disk_id,
    yandex_compute_instance.web_server_b.boot_disk.0.disk_id,
    yandex_compute_instance.elasticsearch.boot_disk.0.disk_id,
    yandex_compute_instance.kibana.boot_disk.0.disk_id,
    yandex_compute_instance.zabbix_server.boot_disk.0.disk_id,
    yandex_compute_instance.bastion_host.boot_disk.0.disk_id
  ]
}