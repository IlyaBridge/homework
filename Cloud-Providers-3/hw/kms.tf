# KMS ключ для шифрования бакета
resource "yandex_kms_symmetric_key" "bucket-key" {
  name              = "bucket-encryption-key"
  description       = "KMS key for bucket encryption"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год

  labels = {
    environment = "hw"
    purpose     = "bucket-encryption"
  }
}

# Права доступа для сервисного аккаунта на использование KMS ключа
resource "yandex_kms_symmetric_key_iam_binding" "viewer" {
  symmetric_key_id = yandex_kms_symmetric_key.bucket-key.id
  role             = "viewer"
  
  members = [
    "serviceAccount:${var.service_account_id}",
  ]
}