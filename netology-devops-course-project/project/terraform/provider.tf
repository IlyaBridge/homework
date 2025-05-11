terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.85.0"  # Минимальная версия провайдера
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.2" # Последняя версия null-провайдера
    }    
  }
  required_version = ">= 1.3.0"  # Минимальная версия Terraform
}

provider "yandex" {
  cloud_id  = "b2gpupamkrr85nd1d32m"  # Идентификатор облака
  folder_id = "b2grpedldfrumqsrjf62"  # Идентификатор каталога
  zone      = "ru-central1-a"          # Зона по умолчанию

  # Путь к файлу сервисного аккаунта (берется из переменной)
  service_account_key_file = var.service_account_key_file
}
