###cloud vars
# Убраны переменные дубли из файла variables.tf оставлены только общие переменные
variable "cloud_id" {
  type        = string
  description = "Cloud ID"
  default     = "b1gpupamkrr85nd1d31m"
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
  default     = "b1grpedldfrumqsrjf62"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Default zone"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "Default CIDR"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC name"
}

###ssh vars
variable "vms_ssh_root_key" {
  type        = string
  description = "SSH public key"
  default     = "ssh-ed25519 AAAAC3NxaC1lZDI1NTE5AAAAIG+Y/MsyrzR2SpC4Nd4JI4/eCRm8cW6CnHUR/b7r96PI"
}

### service account
variable "service_account_key_file" {
  type        = string
  description = "Service account key path"
  default     = "/home/ilya/authorized_key.json"
}

# ###cloud vars


# variable "cloud_id" {
#   type        = string
#   description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
# }

# variable "folder_id" {
#   type        = string
#   description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
# }

# variable "default_zone" {
#   type        = string
#   default     = "ru-central1-a"
#   description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
# }
# variable "default_cidr" {
#   type        = list(string)
#   default     = ["10.0.1.0/24"]
#   description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
# }

# variable "vpc_name" {
#   type        = string
#   default     = "develop"
#   description = "VPC network & subnet name"
# }


# ###ssh vars

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "<your_ssh_ed25519_key>"
#   description = "ssh-keygen -t ed25519"
# }
