# Домашнее задание к занятию "`Основы Terraform. Yandex Cloud`" - `Казначеев Илья`

https://github.com/netology-code/ter-homeworks/blob/main/02/hw-02.md
## Цели задания
1.	Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2.	Освоить работу с переменными Terraform.

## Чек-лист готовности к домашнему заданию
1.	Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2.	Установлен инструмент Yandex CLI.
3.	Исходный код для выполнения задания расположен в директории 02/src. https://github.com/netology-code/ter-homeworks/tree/main/02/src

Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!

---

## Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git. Убедитесь что ваша версия Terraform ~>1.8.4

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. service_account_key_file.
3. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную vms_ssh_public_root_key.
4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.

Ответ: 
4.1. Ошибки в providers.tf
Использование file() для пути с тильдой (~) — Terraform не поддерживает расширение тильды в путях
Жёстко закодированный путь вместо переменной
provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = var.service_account_key_file  # Используем переменную
}

4.2. Ошибки в main.tf
standart-v4 → неправильное написание (правильно standard-v1)
Для standard-v1 минимальное количество ядер — 2 (не 1)
Исправлено:
resource "yandex_compute_instance" "platform" {
  name        = "netology-develop-platform-web"
  platform_id = "standard-v1"  # Исправлено написание
  resources {
    cores         = 2  # Минимум 2 ядра для standard-v1
    memory        = 1
    core_fraction = 5 # Гарантированная доля vCPU 5%
  }
  ...
}

4.3. Пропущены обязательные параметры
Нужно явно указать zone в ресурсе ВМ
Размера boot disk
boot_disk {
  initialize_params {
    image_id = data.yandex_compute_image.ubuntu.image_id
    size     = 10  # Размер диска в GB
  }
}
network_interface {
  subnet_id = yandex_vpc_subnet.develop.id
  nat       = true  # Добавлен параметр NAT
}

5. Подключитесь к консоли ВМ через ssh и выполните команду  curl ifconfig.me. Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: "ssh ubuntu@vm_ip_address". Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: eval $(ssh-agent) && ssh-add Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;

Ответ: 
preemptible = true - прерываемая ВМ
ВМ может быть автоматически остановлена Yandex Cloud в любой момент.
Полезно будет для обучения с точки зрения:
- экономии бюджета, стоимость таких ВМ ниже.
- имитации реальных сценариев. Учит работать с непостоянными ресурсами (как пример, для тестирования отказоустойчивости).
- безопасности экспериментов. Можно смело удалять/пересоздавать ВМ без больших затрат.

core_fraction = 5 - гарантированная доля vCPU
Ограничивает использование CPU до 5% от одного ядра, но позволяет кратковременно использовать больше (до 100%).
Полезно будет для обучения с точки зрения минимизации затрат, то есть ВМ стоит дешевле, чем с полным ядром.

6. Ответьте, как в процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ.

В качестве решения приложите:

-	скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
-	скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
-	ответы на вопросы.

[Файлы задания №1](https://github.com/IlyaBridge/homework/tree/main/Cloud%20infrastructure.%20Terraform-2/task-1)

---

## Задание 2
1. Замените все хардкод-значения для ресурсов yandex_compute_image и yandex_compute_instance на отдельные переменные. К названиям переменных ВМ добавьте в начало префикс vm_web_ . Пример: vm_web_name.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их default прежними значениями из main.tf.
3. Проверьте terraform plan. Изменений быть не должно.

## Ответ 2
[Файлы задания №2](https://github.com/IlyaBridge/homework/tree/main/Cloud%20infrastructure.%20Terraform-2/task-2)

variables.tf с новыми переменными
```
###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  default     = "b1gpupamkrr85nd1d31m"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
  default     = "b1grpedldfrumqsrjf62"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

###ssh vars
variable "vms_ssh_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+Y/MsydzR1SpC4Nd4JI4/eCRm4cW6CnHUR/b7r95PI"
}

### service account
variable "service_account_key_file" {
  type        = string
  description = "Path to Yandex Cloud service account key file"
  default     = "/home/ilya/authorized_key.json"
}

### VM variables
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Name of the VM instance"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Platform ID for the VM"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores"
}

variable "vm_web_memory" {
  type        = number
  default     = 2
  description = "Amount of memory in GB"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 20
  description = "Guaranteed vCPU fraction"
}

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Image family for the boot disk"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Whether the VM is preemptible"
}

variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "Enable NAT for the VM"
}

variable "vm_web_serial_port_enable" {
  type        = number
  default     = 1
  description = "Enable serial port access"
}
```
- Все настройки ВМ вынесены в отдельные переменные.
- Для каждой переменной добавили, type (тип данных), description (описание), default (значение по умолчанию)

Обновленный файл main.tf
```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}

resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  zone        = var.default_zone
  
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat
  }

  metadata = {
    serial-port-enable = var.vm_web_serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
```
Теперь файл состоит из трёх основных блоков:
- Сеть и подсеть (VPC)
- Образ ОС (data-источник)
- Виртуальная машина (основной ресурс)
P.S.
Раньше значения были "зашиты" в коде, теперь их можно менять централизованно через variables.tf или terraform.tfvars.

Результат команды terraform plan

![Ответ 2 0001](https://github.com/user-attachments/assets/ff5b5a35-5120-46dd-ba12-cee13e460e7b)

---

## Задание 3
1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: "netology-develop-platform-db" , cores  = 2, memory = 2, core_fraction = 20. Объявите её переменные с префиксом vm_db_ в том же файле ('vms_platform.tf'). ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

## Ответ 3
[Файлы задания №3](https://github.com/IlyaBridge/homework/tree/main/Cloud%20infrastructure.%20Terraform-2/task-3)

![Задание 3 - 001](https://github.com/user-attachments/assets/f4a04cdc-55fe-487e-9897-78cfece34748)

![Задание 3 - 002](https://github.com/user-attachments/assets/fff40994-2914-47f0-8b6c-acaa9fd01308)

---

## Задание 4
1. Объявите в файле outputs.tf один output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды terraform output.

## Ответ 4
[Файлы задания №4](https://github.com/IlyaBridge/homework/tree/main/Cloud%20infrastructure.%20Terraform-2/task-4)

![Ответ 4](https://github.com/user-attachments/assets/b029aa0f-913f-47dd-a686-850dd1864ac5)

---

## Задание 5
1. В файле locals.tf опишите в одном local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

## Ответ 5
[Файлы задания №5](https://github.com/IlyaBridge/homework/tree/main/Cloud%20infrastructure.%20Terraform-2/task-5)

![Ответ 5 - 1](https://github.com/user-attachments/assets/b2433b52-3ffc-4fd1-9ed6-443932351638)

![Ответ 5 - 2](https://github.com/user-attachments/assets/fecc1b5e-fb6a-433f-b3cc-e8e06533d6c8)

---

## Задание 6
1. Вместо использования трёх переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедините их в единую map-переменную vms_resources и внутри неё конфиги обеих ВМ в виде вложенного map(object).

пример из terraform.tfvars:
```
vms_resources = {
  web={
    cores=2
    memory=2
    core_fraction=5
    hdd_size=10
    hdd_type="network-hdd"
    ...
  },
  db= {
    cores=2
    memory=4
    core_fraction=20
    hdd_size=10
    hdd_type="network-ssd"
    ...
  }
}
```
2. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.

пример из terraform.tfvars:
```
metadata = {
  serial-port-enable = 1
  ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
}
```

3. Найдите и закоментируйте все, более не используемые переменные проекта.

4. Проверьте terraform plan. Изменений быть не должно.

## Ответ 6

[Файлы задания №6](https://github.com/IlyaBridge/homework/tree/main/Cloud%20infrastructure.%20Terraform-2/task-6)

---

## Дополнительное задание (со звёздочкой*)
Настоятельно рекомендуем выполнять все задания со звёздочкой.
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию.

---

## Задание 7*
Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания:

1/ Напишите, какой командой можно отобразить второй элемент списка test_list.
2/ Найдите длину списка test_list с помощью функции length(<имя переменной>).
3/ Напишите, какой командой можно отобразить значение ключа admin из map test_map.
4/ Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.
Примечание: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.

---

## Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.

---

## Задание 9*
Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1
настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu

---

Правила приёма работыДля подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu
В качестве результата прикрепите ссылку на MD файл с описанием выполненой работы в вашем репозитории. Так же в репозитории должен присутсвовать ваш финальный код проекта.

Важно. Удалите все созданные ресурсы.

Критерии оценки
Зачёт ставится, если:

выполнены все задания,
ответы даны в развёрнутой форме,
приложены соответствующие скриншоты и файлы проекта,
в выполненных заданиях нет противоречий и нарушения логики.
На доработку работу отправят, если:

задание выполнено частично или не выполнено вообще,
в логике выполнения заданий есть противоречия и существенные недостатки.

