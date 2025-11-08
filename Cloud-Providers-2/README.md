#  «Домашнее задание к занятию» "`«Вычислительные мощности. Балансировщики нагрузки»`" - `Казначеев Илья`

https://github.com/netology-code/clopro-homeworks/blob/main/15.2.md

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.
4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

---

## Решение

[Файлы задания](https://github.com/IlyaBridge/homework/tree/main/Cloud-Providers-2/hw)

### 1. Созданные ресурсы

![00001 - terraform output](https://github.com/user-attachments/assets/ab18374f-99b5-4965-83b8-108a226051bc)

### 2. Веб-страница через балансировщик

![00002-1 curl http](https://github.com/user-attachments/assets/64ed9e90-d5e9-47bf-baa1-9c22a456bea7)

![00002-2 curl http](https://github.com/user-attachments/assets/701ab258-8b3d-4d05-a759-8b187cb1d437)

### 3. Проверка доступности картинки в Object Storage

![00003 curl -I https](https://github.com/user-attachments/assets/65149f06-1b50-4de2-ae76-7529285d5183)

### 4. Instance Group

![00004 yc compute instance-group](https://github.com/user-attachments/assets/5244d90c-7420-4110-aa24-38d299b0ad3e)

### 5. Load Balancer

![00005 yc load-balancer network-load-balancer](https://github.com/user-attachments/assets/81202088-69bd-4929-aeaa-032d5b0784b8)

---

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

---
