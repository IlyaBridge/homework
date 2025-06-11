### VM Web Variables
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Web VM name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Web VM platform"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores for web VM"
}

variable "vm_web_memory" {
  type        = number
  default     = 2
  description = "Amount of memory in GB for web VM"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 20
  description = "Guaranteed vCPU fraction for web VM"
}

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Image family for the web VM boot disk"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Whether the web VM is preemptible"
}

variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "Enable NAT for the web VM"
}

variable "vm_web_serial_port_enable" {
  type        = number
  default     = 1
  description = "Enable serial port access for web VM"
}

### VM DB Variables
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "DB VM name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "DB VM platform"
}

variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores for DB VM"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description = "Amount of memory in GB for DB VM"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description = "Guaranteed vCPU fraction for DB VM"
}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "Zone for the DB VM"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "Whether the DB VM is preemptible"
}

variable "vm_db_nat" {
  type        = bool
  default     = true
  description = "Enable NAT for the DB VM"
}

variable "vm_db_serial_port_enable" {
  type        = number
  default     = 1
  description = "Enable serial port access for DB VM"
}