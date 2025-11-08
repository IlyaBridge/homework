# Создание бакета Object Storage
resource "yandex_storage_bucket" "hw_bucket" {
  bucket     = "ilya-08-11-2025"
  
  # Ключи будут созданы через переменные или data sources
  # access_key = "ACCESS_KEY"
  # secret_key = "SECRET_KEY"

  anonymous_access_flags {
    read = true
    list = false
  }

  max_size = 1073741824 # 1GB
}

# Загрузка файла с картинкой в бакет
resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.hw_bucket.bucket
  key    = "image.jpg"
  source = "/home/ilya/yandex-cloud-hw/cat777.jpg"
  acl    = "public-read"
}