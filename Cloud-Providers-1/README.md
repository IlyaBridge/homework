#  «Домашнее задание к занятию» "`«Организация сети»`" - `Казначеев Илья`

https://github.com/netology-code/clopro-homeworks/blob/main/15.1.md

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашнее задание по теме «Облачные провайдеры и синтаксис Terraform». Заранее выберите регион (в случае AWS) и зону.

---
### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).

---

## Решение

[Файлы задания](https://github.com/IlyaBridge/homework/tree/main/Cloud-Providers-1/hw)

Проверка создания VPC:

![0001 ШАГ 1 Проверка создания VPC](https://github.com/user-attachments/assets/2194f50f-36aa-497e-b64e-2b1d4683ce7f)


Проверка публичной подсети

![0002  ШАГ 2 Проверка публичной подсети](https://github.com/user-attachments/assets/46ac1f8f-6332-45ec-8704-2b3b942e185f)

Проверка NAT-инстанса

![0003  ШАГ 3 Проверка NAT-инстанса](https://github.com/user-attachments/assets/40325c74-5567-439a-af65-b9b9577f2889)

Полная информация о сети NAT-инстанса

![0003-2  ШАГ 3 Полная информация о сети NAT-инстанса](https://github.com/user-attachments/assets/911c99dc-bb91-4207-9463-eaddfc7b43a6)

Проверка виртуальной машины в публичной подсети

![0004  ШАГ 4 Проверка виртуальной машины в публичной подсети](https://github.com/user-attachments/assets/438f27bd-deed-4975-a1f1-b933334013e8)

Подключение к public VM и проверка доступа к интернету

![0005-1 ШАГ 5 Подключаемся к public VM](https://github.com/user-attachments/assets/338d25b4-54ad-4b65-b79f-9af2b068b8f8)

Проверяем сетевую конфигурацию

![0005-2 ШАГ 5 Проверяем сетевую конфигурацию](https://github.com/user-attachments/assets/ed54123a-d8b5-4978-9ac8-385715717da6)

Проверяем доступ к интернету

![0005-3 ШАГ 5 Проверяем доступ к интернету](https://github.com/user-attachments/assets/09147386-dc9a-4aad-8cec-56a07a3fc6e0)

Проверяем DNS разрешение

![0005-4 ШАГ 5 Проверяем DNS разрешение](https://github.com/user-attachments/assets/e51ea6c4-a25b-4289-921c-2d4b17acc100)

Проверяем HTTP доступ

![0005-5 ШАГ 5 Проверяем HTTP доступ](https://github.com/user-attachments/assets/fcc727ed-16d3-4b84-9638-e8595ac55486)

Проверка приватной подсети

![0006 ШАГ 6 Проверка приватной подсети](https://github.com/user-attachments/assets/a4ff4902-f488-4782-a866-3599fcda2906)

Проверка таблицы маршрутизации

![0007 ШАГ 7 Проверка таблицы маршрутизации](https://github.com/user-attachments/assets/b49ee7fe-2830-47db-8915-ff79295ce308)

Проверка виртуальной машины в приватной подсети

![0008 ШАГ 8 Проверка виртуальной машины в приватной подсети](https://github.com/user-attachments/assets/3ee35d58-df45-45cc-a441-963d215b72e1)

Подключение к private VM через Jump host

![0009 ШАГ 9 Подключение джампом](https://github.com/user-attachments/assets/c8e69ff7-03c7-46ae-aba2-17c5383c5493)

Проверяем таблицу маршрутизации 

![0009-2 ШАГ 9 Проверяем таблицу маршрутизации](https://github.com/user-attachments/assets/4d8fc80c-37c7-48c7-9088-17340c35e5bd)

Проверяем доступ к интернету через NAT

![0009-3 ШАГ 9 Проверяем доступ к интернету через NAT](https://github.com/user-attachments/assets/9753180c-70f9-41b7-95a8-d75218a7f285)

Проверяем DNS разрешение через NAT

![0009-4 ШАГ 9 Проверяем доступ к интернету через NAT](https://github.com/user-attachments/assets/efbd8a29-24c1-484e-b0a4-48bfb80ae3a5)

Проверяем HTTP доступ через NAT

![0009-5 ШАГ 9 Проверяем HTTP доступ через NAT](https://github.com/user-attachments/assets/22f1c7c0-b4ef-4f78-aa80-7a083566bd51)

---

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

---
