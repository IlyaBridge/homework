output "static_ip" {
  value = yandex_vpc_address.static_ip.external_ipv4_address[0].address
}

output "public_vm_ip" {
  value = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
}

output "private_vm_ip" {
  value = yandex_compute_instance.private-vm.network_interface.0.ip_address
}

output "lamp_group_instances" {
  value = [
    for instance in yandex_compute_instance_group.lamp_group.instances : {
      name   = instance.name
      status = instance.status
      ip     = instance.network_interface[0].ip_address
    }
  ]
}

output "load_balancer_ip" {
  value = try(
    [for listener in yandex_lb_network_load_balancer.lamp_balancer.listener : listener.external_address_spec[0].address if listener.name == "lamp-listener"][0],
    "Load balancer IP will be available after creation"
  )
}

output "image_url" {
  value = "https://${yandex_storage_bucket.hw_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.image.key}"
}

output "bucket_name" {
  value = yandex_storage_bucket.hw_bucket.bucket
}