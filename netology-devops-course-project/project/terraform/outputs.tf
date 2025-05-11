# /home/ilya/project/terraform/outputs.tf

output "bastion_external_ip" {
  value = yandex_compute_instance.bastion_host.network_interface.0.nat_ip_address
}

output "load_balancer_ip" {
  value = yandex_alb_load_balancer.web_balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "web_servers_ips" {
  value = {
    "web-server-a" = yandex_compute_instance.web_server_a.network_interface.0.ip_address
    "web-server-b" = yandex_compute_instance.web_server_b.network_interface.0.ip_address
    "bastion-host" = yandex_compute_instance.bastion_host.network_interface.0.nat_ip_address
    "zabbix-server" = yandex_compute_instance.zabbix_server.network_interface.0.ip_address
    "elasticsearch" = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
  }
}
