# /home/ilya/project/terraform/network.tf

resource "yandex_vpc_network" "main" {
  name = "main-network-${formatdate("DDMMYYYY-hhmm", timestamp())}"
    description = "Network for Zabbix and related services"
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
    shared_egress_gateway {}
    lifecycle {
    prevent_destroy = false
  }
}

# Таблица маршрутизации для NAT
resource "yandex_vpc_route_table" "nat" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Публичная подсеть (для bastion, ALB, Zabbix, Kibana)
resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["192.168.10.0/24"]

  # Явно разрешаем публичный доступ
  route_table_id = yandex_vpc_route_table.nat.id
}

# Приватная подсеть (для веб-серверов и Elasticsearch)
resource "yandex_vpc_subnet" "private_a" {
  name           = "private-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat.id
}

resource "yandex_vpc_subnet" "private_b" {
  name           = "private-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["192.168.30.0/24"]
  route_table_id = yandex_vpc_route_table.nat.id
}
