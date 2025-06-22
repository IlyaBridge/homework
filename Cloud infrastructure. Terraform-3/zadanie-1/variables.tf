variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Default zone for resources"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "Default CIDR block for subnet"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network name"
}