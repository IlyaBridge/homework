output "inventory" {
  value = local_file.ansible_inventory.content
}
