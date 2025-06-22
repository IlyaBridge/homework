variable "security_group_ingress" {
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP",
      description    = "Allow SSH",
      v4_cidr_blocks = ["0.0.0.0/0"],
      port           = 22
    },
    {
      protocol       = "TCP",
      description    = "Allow HTTP",
      v4_cidr_blocks = ["0.0.0.0/0"],
      port           = 80
    },
    {
      protocol       = "TCP",
      description    = "Allow HTTPS",
      v4_cidr_blocks = ["0.0.0.0/0"],
      port           = 443
    }
  ]
}

variable "security_group_egress" {
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP",
      description    = "Allow all outbound",
      v4_cidr_blocks = ["0.0.0.0/0"],
      from_port      = 0,
      to_port        = 65535
    }
  ]
}

resource "yandex_vpc_security_group" "example" {
  name       = "example-dynamic-sg"
  network_id = yandex_vpc_network.develop.id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      protocol       = ingress.value.protocol
      description    = ingress.value.description
      v4_cidr_blocks = ingress.value.v4_cidr_blocks
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = egress.value.protocol
      description    = egress.value.description
      v4_cidr_blocks = egress.value.v4_cidr_blocks
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
    }
  }
}