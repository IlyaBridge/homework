# Целевая группа для балансировщика
resource "yandex_lb_target_group" "lamp_target_group" {
  name      = "lamp-target-group"
  folder_id = "b1grpedldfrumqsrjf62"

  dynamic "target" {
    for_each = yandex_compute_instance_group.lamp_group.instances
    content {
      subnet_id = yandex_vpc_subnet.public.id
      address   = target.value.network_interface[0].ip_address
    }
  }
}

# Сетевой балансировщик
resource "yandex_lb_network_load_balancer" "lamp_balancer" {
  name      = "lamp-network-balancer"
  folder_id = "b1grpedldfrumqsrjf62"

  listener {
    name = "lamp-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lamp_target_group.id

    healthcheck {
      name                = "http"
      interval            = 2
      timeout             = 1
      unhealthy_threshold = 2
      healthy_threshold   = 2
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}