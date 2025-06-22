terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.142.0"
    }
  }
  required_version = ">=1.8.4"
}

provider "yandex" {
  service_account_key_file = "/home/ilya/service_account_key_file.json"
  cloud_id                 = "b1gpupamkrr85nd1d31m"
  folder_id                = "b1grpedldfrumqsrjf62"
  zone                     = "ru-central1-a"
}