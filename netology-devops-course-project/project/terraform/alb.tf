# /home/ilya/project/terraform/alb.tf

# Target Group - группа целевых серверов
resource "yandex_alb_target_group" "web_servers" {
  name = "web-servers-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.private_a.id
    ip_address = yandex_compute_instance.web_server_a.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.private_b.id
    ip_address = yandex_compute_instance.web_server_b.network_interface.0.ip_address
  }
}

# Backend Group - группа бэкендов
resource "yandex_alb_backend_group" "web_backend" {
  name = "web-backend-group"

  http_backend {
    name             = "web-backend"
    weight          = 1
    port            = 80
    target_group_ids = [yandex_alb_target_group.web_servers.id]
    
    healthcheck {
      timeout          = "10s"
      interval         = "2s"
      healthy_threshold   = 5
      unhealthy_threshold = 3
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# HTTP Router - маршрутизатор HTTP
resource "yandex_alb_http_router" "web_router" {
  name = "web-router-${formatdate("DDMMYYYY-hhmm", timestamp())}"
# resource "yandex_alb_http_router" "web_router" {
#   name = "web-router"
}

# Virtual Host - виртуальный хост
resource "yandex_alb_virtual_host" "web_host" {
  name           = "web-host"
  http_router_id = yandex_alb_http_router.web_router.id
  
  route {
    name = "root"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_backend.id
      }
    }
  }
}

# Application Load Balancer
resource "yandex_alb_load_balancer" "web_balancer" {
  name        = "web-balancer"
  network_id  = yandex_vpc_network.main.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }
# -----------------------------------
  depends_on = [
    yandex_alb_target_group.web_servers,
    yandex_alb_http_router.web_router
  ]
# -----------------------------------
}