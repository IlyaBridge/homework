# /home/ilya/project/terraform/web_servers.tf

resource "yandex_compute_instance" "web_server_a" {
  name        = "web-server-a"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8pfd17g205ujpmpb0a" # Ubuntu 24.04
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_a.id
    nat       = false
  }

  metadata = {
    user-data = file("${path.module}/cloud-init.yml")
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "web_server_b" {
  name        = "web-server-b"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8pfd17g205ujpmpb0a" # Ubuntu 24.04
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_b.id
    nat       = false
  }

  metadata = {
    user-data = file("${path.module}/cloud-init.yml")
  }

  scheduling_policy {
    preemptible = true
  }
}

# Добаввление хука для автозаполняемого файла inventory

resource "null_resource" "generate_inventory" {
  triggers = {
    # Триггеры на изменение IP-адресов
    web_a_ip     = yandex_compute_instance.web_server_a.network_interface.0.ip_address
    web_b_ip     = yandex_compute_instance.web_server_b.network_interface.0.ip_address
    bastion_ip   = yandex_compute_instance.bastion_host.network_interface.0.nat_ip_address
    zabbix_ip    = yandex_compute_instance.zabbix_server.network_interface.0.ip_address
    elastic_ip   = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
  }

  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      cd ${path.module}/../ansible
      jq -n --arg bastion "$BASTION" \
             --arg web_a "$WEB_A" \
             --arg web_b "$WEB_B" \
             --arg zabbix "$ZABBIX" \
             --arg elastic "$ELASTIC" \
      '{
        "bastion": { "hosts": { "bastion-host": { "ansible_host": $bastion, "ansible_user": "ilya" } } },
        "web_servers": { 
          "hosts": { 
            "web-server-a": { "ansible_host": $web_a, "ansible_user": "ilya", "ansible_ssh_common_args": "-o ProxyCommand=\"ssh -W %h:%p -q ilya@\($bastion)\"" },
            "web-server-b": { "ansible_host": $web_b, "ansible_user": "ilya", "ansible_ssh_common_args": "-o ProxyCommand=\"ssh -W %h:%p -q ilya@\($bastion)\"" }
          }
        },
        "zabbix": { "hosts": { "zabbix-server": { "ansible_host": $zabbix, "ansible_user": "ilya", "ansible_ssh_common_args": "-o ProxyCommand=\"ssh -W %h:%p -q ilya@\($bastion)\"" } } },
        "elk": { "hosts": { "elasticsearch": { "ansible_host": $elastic, "ansible_user": "ilya", "ansible_ssh_common_args": "-o ProxyCommand=\"ssh -W %h:%p -q ilya@\($bastion)\"" } } }
      }' > inventory.json
    EOT

    environment = {
      BASTION  = yandex_compute_instance.bastion_host.network_interface.0.nat_ip_address
      WEB_A    = yandex_compute_instance.web_server_a.network_interface.0.ip_address
      WEB_B    = yandex_compute_instance.web_server_b.network_interface.0.ip_address
      ZABBIX   = yandex_compute_instance.zabbix_server.network_interface.0.ip_address
      ELASTIC  = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
    }
  }

  depends_on = [
    yandex_compute_instance.web_server_a,
    yandex_compute_instance.web_server_b,
    yandex_compute_instance.bastion_host,
    yandex_compute_instance.zabbix_server,
    yandex_compute_instance.elasticsearch
  ]
}
