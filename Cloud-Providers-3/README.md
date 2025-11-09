#  «Домашнее задание к занятию» "`«Безопасность в облачных провайдерах»`" - `Казначеев Илья`

https://github.com/netology-code/clopro-homeworks/blob/main/15.3.md

Используя конфигурации, выполненные в рамках предыдущих домашних заданий, нужно добавить возможность шифрования бакета.

---
## Задание 1. Yandex Cloud   

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:

 - создать ключ в KMS;
 - с помощью ключа зашифровать содержимое бакета, созданного ранее.

<!-- 2. (Выполняется не в Terraform)* Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS:

 - создать сертификат;
 - создать статическую страницу в Object Storage и применить сертификат HTTPS;
 - в качестве результата предоставить скриншот на страницу с сертификатом в заголовке (замочек).

Полезные документы:

- [Настройка HTTPS статичного сайта](https://cloud.yandex.ru/docs/storage/operations/hosting/certificate).
- [Object Storage bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket).
- [KMS key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key). -->

---

## Решение

[Файлы задания](https://github.com/IlyaBridge/homework/tree/main/Cloud-Providers-3/hw)

### Проверяем ключ 

```
yc kms symmetric-key get $KMS_KEY_ID
```

![0001 Проверяем ключ через YC CLI](https://github.com/user-attachments/assets/96baac61-5a36-4cdb-911d-e30fcaf3e737)

```
yc kms symmetric-key list
```

![0002-1 Проверка KMS ключа](https://github.com/user-attachments/assets/b721abc0-d5ef-4aa1-9364-72372345902b)

### Проверяем, что бакет зашифрован

```
yc storage bucket get ilya-08-11-2025 --full 
```

![0002-2 Проверяем, что бакет зашифрован](https://github.com/user-attachments/assets/ca0c9e92-b9b9-44b0-aa89-560f88eb32bb)

### Проверяем доступность изображения

```
curl -I https://storage.yandexcloud.net/ilya-08-11-2025/image.jpg
```

![0003-Проверяем доступность изображения](https://github.com/user-attachments/assets/454ed01f-f005-48ac-a266-7505630db04d)

---

### Правила приёма работы
Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

---
