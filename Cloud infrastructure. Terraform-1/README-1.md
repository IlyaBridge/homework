# Домашнее задание к занятию "`Введение в Terraform`" - `Казначеев Илья`

Домашнее задание: https://github.com/netology-code/ter-homeworks/blob/main/01/hw-01.md

Цели задания
1.	Установить и настроить Terrafrom.
2.	Научиться использовать готовый код.

Чек-лист готовности к домашнему заданию
1.	Скачайте и установите Terraform версии >=1.8.4 . Приложите скриншот вывода команды terraform --version.
2.	Скачайте на свой ПК этот git-репозиторий. Исходный код для выполнения задания расположен в директории 01/src.
3.	Убедитесь, что в вашей ОС установлен docker.

Инструменты и дополнительные материалы, которые пригодятся для выполнения задания
1.	Репозиторий с ссылкой на зеркало для установки и настройки Terraform: ссылка. https://github.com/netology-code/devops-materials
2.	Установка docker: ссылка. 
https://docs.docker.com/engine/install/ubuntu/

### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!

---

## Задание 1
1.	Перейдите в каталог src. Скачайте все необходимые зависимости, использованные в проекте.

2.	Изучите файл .gitignore. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)

3.	Выполните код проекта. Найдите в state-файле секретное содержимое созданного ресурса random_password, пришлите в качестве ответа конкретный ключ и его значение.

4.	Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла main.tf. Выполните команду terraform validate. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.

5.	Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды docker ps.

6.	Замените имя docker-контейнера в блоке кода на hello_world. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду terraform apply -auto-approve. Объясните своими словами, в чём может быть опасность применения ключа -auto-approve. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды docker ps.

7.	Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.

8.	Объясните, почему при этом не был удалён docker-образ nginx:latest. Ответ ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ, а затем ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ строчкой из документации terraform провайдера docker. (ищите в классификаторе resource docker_image )
Дополнительное задание (со звёздочкой*)
Настоятельно рекомендуем выполнять все задания со звёздочкой. Они помогут глубже разобраться в материале.
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию.

---

### 2
Личный секретный файл
Согласно .gitignore, личную секретную информацию можно хранить в файле:
personal.auto.tfvars
Строка:
```
# own secret vars store.
```
personal.auto.tfvars
Файлы с расширением «.auto.tfvars» автоматически загружаются Terraform при выполнении, но так же их можно исключить из Git с помощью .gitignore.

---

### 3
Изменим файл main.tf:
```
terraform {
required_providers {
yandex = {
source = "yandex-cloud/yandex"
version = ">= 0.85.0"
}
random = {
source = "hashicorp/random"
version = "~> 3.0"
}
docker = {
source = "kreuzwerker/docker"
version = "~> 3.0.1"
}
}
required_version = ">=1.8.4" /*Многострочный комментарий.
Требуемая версия terraform */
}
provider "docker" {}
 
#однострочный комментарий
 
resource "random_password" "random_string" {
length = 16
special = false
min_upper = 1
min_lower = 1
min_numeric = 1
}
 
/*
resource "docker_image" {
name = "nginx:latest"
keep_locally = true
}
 
resource "docker_container" "1nginx" {
image = docker_image.nginx.image_id
name = "example_${random_password.random_string_FAKE.resulT}"
 
ports {
internal = 80
external = 9090
}
}
*/
```
После выполнения terraform apply в terraform.tfstate находим:

![Задание 1 п 2 Ответ 0001](https://github.com/user-attachments/assets/36a30cb4-65d7-4f2d-87b5-bafa9031cd3d)

![Задание 1 п 2 Ответ 0002](https://github.com/user-attachments/assets/1b793b99-8cf8-4a4d-b4c3-3e9f20ab5b5b)
Ключ: result, значение: 2Hll8EiDOOLGjVKr.

---

### 4 Ошибки в раскомментированном коде
Исправленный код:
```
resource "docker_image" "nginx" {  # Добавлено имя ресурса
  name         = "nginx:latest"    # Строковое значение в двойных кавычках
  keep_locally = true              # Сохранять образ после удаления ресурса
}

resource "docker_container" "nginx" {  # Исправлено имя с 1nginx на nginx
  image = docker_image.nginx.image_id  # Правильная ссылка на образ
  name  = "example_${random_password.random_string.result}"  # Исправлена опечатка в result

  ports {
    internal = 80
    external = 9090
  }
}
```
![Задание 1 п 3 Ответ 0001](https://github.com/user-attachments/assets/761536ff-bda0-4f67-98f1-a5e6839eb689)

---

### 5 Выполнение исправленного кода
Вывод docker ps после исправления:

![Задание 1 п 4 Ответ 0001](https://github.com/user-attachments/assets/915365db-8261-4509-af40-92b1cdc17e48)

---

### 6 Замена имени контейнера и auto-approve
Изменяем имя контейнера на hello_world:
```
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "hello_world"
```
Выполним команду terraform apply -auto-approve:
![Задание 1 п 5 Ответ 0001](https://github.com/user-attachments/assets/e62c15c1-7a0b-4a10-982a-87c13f4c9348)

Вывод docker ps после применения:
![Задание 1 п 5 Ответ 0002](https://github.com/user-attachments/assets/47d1c9ae-d513-4ed9-b178-e359ad087ec8)

---

### 7 Уничтожение ресурсов
После terraform destroy содержимое terraform.tfstate:
![Задание 1 п 6 Ответ 0001](https://github.com/user-attachments/assets/f25dcdea-0d3f-4a4a-bcf7-1b017c0a33a7)

---

### 8 Почему не удалился образ nginx
В коде явно указано:
![Задание 1 п 7 Ответ 0001](https://github.com/user-attachments/assets/4ac8aaeb-7237-4fe3-99d7-8464b7b3bdab)

Из документации провайдера docker:
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.
Это означает, что образ специально оставлен в локальном хранилище Docker для возможного повторного использования.

---
