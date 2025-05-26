# Домашнее задание к занятию "`Оркестрация группой Docker контейнеров на примере Docker Compose`" - `Казначеев Илья`

---
Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1
Сценарий выполнения задачи:
Установите docker и docker compose plugin на свою linux рабочую станцию или ВМ.
Зарегистрируйтесь и создайте публичный репозиторий с именем "custom-nginx" на https://hub.docker.com;
скачайте образ nginx:1.21.1;
Создайте Dockerfile и реализуйте в нем замену дефолтной индекс-страницы(/usr/share/nginx/html/index.html), на файл index.html с содержимым:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
```
Соберите и отправьте созданный образ в свой dockerhub-репозитории c tag 1.0.0 .
Предоставьте ответ в виде ссылки на https://hub.docker.com/<username_repo>/custom-nginx/general.

### Решение 1

https://hub.docker.com/repository/docker/ilyabridge/custom-nginx/general

---

### Задание 2
Запустите ваш образ custom-nginx:1.0.0 командой docker run в соответвии с требованиями:
имя контейнера "ФИО-custom-nginx-t2"
контейнер работает в фоне
контейнер опубликован на порту хост системы 127.0.0.1:8080
Переименуйте контейнер в "custom-nginx-t2"
Выполните команду date +"%d-%m-%Y %T.%N %Z" && sleep 0.150 && docker ps && ss -tlpn | grep 127.0.0.1:8080  && docker logs custom-nginx-t2 -n1 && docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html
Убедитесь с помощью curl или веб браузера, что индекс-страница доступна.
В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

### Решение 2

![Задание 2 Ответ](https://github.com/user-attachments/assets/74e3fe4c-d50a-47c9-af0a-d9e594a6ccc1)

---

### Задание 3
Воспользуйтесь docker help или google, чтобы узнать, как подключиться к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2".
Подключитесь к контейнеру и нажмите комбинацию Ctrl-C.
Выполните docker ps -a и объясните своими словами почему контейнер остановился.
Перезапустите контейнер
Зайдите в интерактивный терминал контейнера "custom-nginx-t2" с оболочкой bash.
Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
Отредактируйте файл "/etc/nginx/conf.d/default.conf", заменив порт "listen 80" на "listen 81".
Запомните(!) и выполните команду nginx -s reload, а затем внутри контейнера curl http://127.0.0.1:80 && curl http://127.0.0.1:81.
Выйдите из контейнера, набрав в консоли exit или Ctrl-D.
Проверьте вывод команд: ss -tlpn | grep 127.0.0.1:8080 , docker port custom-nginx-t2, curl http://127.0.0.1:8080. Кратко объясните суть возникшей проблемы.

Это дополнительное, необязательное задание. Попробуйте самостоятельно исправить конфигурацию контейнера, используя доступные источники в интернете. Не изменяйте конфигурацию nginx и не удаляйте контейнер. Останавливать контейнер можно. пример источника
Удалите запущенный контейнер "custom-nginx-t2", не останавливая его.(воспользуйтесь --help или google)
В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

### Решение 3
Подключение к потокам ввода/вывода контейнера и остановка
``` docker attach custom-nginx-t2 ```

![000001](https://github.com/user-attachments/assets/f4703797-7189-4655-a20a-c676acf1f811)

Что произойдет?
- В этот момент произойдёт подключение к процессу nginx (т.к. он основной в контейнере).
- При нажатии Ctrl+C процесс nginx завершится → контейнер остановится (т.к. основной процесс будет завершен).

Проверка статуса:
``` docker ps -a ```

![000002](https://github.com/user-attachments/assets/aeb0acdc-a0b6-4d93-bbaf-078d2d1a1a15)

- Контейнер в статусе Exited, потому что nginx был убит сигналом SIGINT (Ctrl+C).

2. Перезапуск контейнера
``` docker start custom-nginx-t2 ```

![000003](https://github.com/user-attachments/assets/c76fa806-b7da-44d1-930f-333d8d61c108)

3. Вход в интерактивный терминал контейнера
``` docker exec -it custom-nginx-t2 bash ```

4. Установка текстового редактора (например, nano)
``` apt-get update && apt-get install -y nano ```

![000004 (установка txt редактора)](https://github.com/user-attachments/assets/23db18d1-1686-48fb-bb6d-3f4d4e8a9d80)

5. Изменение конфигурации Nginx
- Открываем конфиг:
``` nano /etc/nginx/conf.d/default.conf ```
- Меняем порт:
``` listen 81;  # Было: listen 80; ```

![000005](https://github.com/user-attachments/assets/025b9c09-d637-4b0d-9dad-526c2b8b5d70)

- Перезагружаем nginx:
``` nginx -s reload ```

![000006](https://github.com/user-attachments/assets/1dacfdff-40d2-4ce5-a017-8af102899972)

- Проверяем доступность портов:
``` curl http://127.0.0.1:80 ```

![000007](https://github.com/user-attachments/assets/44a7b1c4-6c71-4f77-badb-fb299ee72b5b)

``` curl http://127.0.0.1:81 ```

![000008](https://github.com/user-attachments/assets/ff9c82bf-1dc0-42ad-84c1-42e5b97ffd4b)

6. Проверка снаружи контейнера
```
ss -tlpn | grep 127.0.0.1:8080
docker port custom-nginx-t2
curl http://127.0.0.1:8080
```

![000009](https://github.com/user-attachments/assets/a9953b6e-80cc-4c1f-93f4-6b86c21752ed)

Проблема:
Контейнер пробрасывает хост:8080 → контейнер:80, но nginx теперь слушает 81.
Решение: пересоздать контейнер с пробросом 8080:81 или вернуть listen 80.

7. Удаление контейнера без остановки (принудительно)
``` docker rm -f custom-nginx-t2 ```

![000010](https://github.com/user-attachments/assets/ff9f4269-d9c7-4b6d-bfbe-345b66f73891)

---

### Задание 4
Запустите первый контейнер из образа centos c любым тегом в фоновом режиме, подключив папку текущий рабочий каталог $(pwd) на хостовой машине в /data контейнера.
Запустите второй контейнер из образа debian в фоновом режиме, подключив текущий рабочий каталог $(pwd) в /data контейнера.
Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data.
Добавьте ещё один файл в каталог /data на хостовой машине.
Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

### Решение 4
1. Проверка запущенных контейнеров:
``` docker ps ```

![4000003](https://github.com/user-attachments/assets/0e86b548-c52f-4ec7-bec1-d790e0fc37f4)

Подключение к контейнеру и создание файла:
``` docker exec -it centos-container bash ```
Внутри контейнера:
``` echo 'Hello from CentOS!' > /data/centos_file.txt ```
После выполнения любой из этих команд проверьте создание файла:
``` cat /data/centos_file.txt ```

![4000004](https://github.com/user-attachments/assets/34e4a827-515d-4186-8f91-e993d188d527)

3. Добавление файла на хостовой машине
Создаем файл в текущей директории (он автоматически появится в /data контейнеров):
``` echo "Hello from Host!" > ./host_file.txt ```

![4000005](https://github.com/user-attachments/assets/b6dc3623-6a0a-45d6-800c-f2d3850ff363)

4. Проверка файлов во втором контейнере (Debian)
Подключение к контейнеру:
``` docker exec -it debian-container bash ```

Проверка содержимого /data:
``` ls -l /data ```

![4000006](https://github.com/user-attachments/assets/b0cd05a8-27ef-47a9-974e-e507e3ff1555)

``` cat /data/centos_file.txt ```

![4000007](https://github.com/user-attachments/assets/d3f16daf-9b95-48ed-ba4b-59fe9b9f4b76)

``` cat /data/host_file.txt ```

![4000008](https://github.com/user-attachments/assets/d684023a-e629-407a-a0ec-3f8c17f8a934)

---

### Задание 5
Создайте отдельную директорию(например /tmp/netology/docker/task5) и 2 файла внутри него. "compose.yaml" с содержимым:
```
version: "3"
services:
  portainer:
    image: portainer/portainer-ce:latest
    network_mode: host
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
"docker-compose.yaml" с содержимым:
```
version: "3"
services:
  registry:
    image: registry:2
    network_mode: host
    ports:
    - "5000:5000"
```
И выполните команду "docker compose up -d". Какой из файлов был запущен и почему? (подсказка: https://docs.docker.com/compose/compose-file/03-compose-file/)
Отредактируйте файл compose.yaml так, чтобы были запущенны оба файла. (подсказка: https://docs.docker.com/compose/compose-file/14-include/)
Выполните в консоли вашей хостовой ОС необходимые команды чтобы залить образ custom-nginx как custom-nginx:latest в запущенное вами, локальное registry. Дополнительная документация: https://distribution.github.io/distribution/about/deploying/
Откройте страницу "https://127.0.0.1:9000" и произведите начальную настройку portainer.(логин и пароль адмнистратора)
Откройте страницу "http://127.0.0.1:9000/#!/home", выберите ваше local окружение. Перейдите на вкладку "stacks" и в "web editor" задеплойте следующий компоуз:
```
version: '3'

services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"
```
Перейдите на страницу "http://127.0.0.1:9000/#!/2/docker/containers", выберите контейнер с nginx и нажмите на кнопку "inspect". В представлении <> Tree разверните поле "Config" и сделайте скриншот от поля "AppArmorProfile" до "Driver".
Удалите любой из манифестов компоуза(например compose.yaml). Выполните команду "docker compose up -d". Прочитайте warning, объясните суть предупреждения и выполните предложенное действие. Погасите тестовый стенд ОДНОЙ(обязательно!!) командой.
В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод, файл compose.yaml , скриншот portainer c задеплоенным компоузом.

---

### Решение 5
1. Запуск docker compose up -d
``` docker compose up -d ```
Результат:
Будет запущен docker-compose.yaml, потому что:
Docker Compose по умолчанию ищет файлы с именами compose.yaml или docker-compose.yaml.
Если оба файла существуют, используется docker-compose.yaml (приоритет у старого формата имени).

![0500002](https://github.com/user-attachments/assets/1a8653c8-6298-4479-8892-4091c3f4a71c)

2. Объединение манифестов через include
Изменим compose.yaml:
```
version: "3.8"
include:
  - docker-compose.yaml
services:
  portainer:
    image: portainer/portainer-ce:latest
    network_mode: host
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
и запустим
``` docker compose -f compose.yaml up -d ```

![0500003](https://github.com/user-attachments/assets/9680c98c-33aa-4f09-85e8-ecc47334d5dc)

3. Загрузка образа в локальное Registry
```
docker tag ilyabridge/custom-nginx:1.0.0 127.0.0.1:5000/custom-nginx:1.0.0
```

![0500003-2](https://github.com/user-attachments/assets/9256e11f-7d24-4324-b398-502c95cc30cd)

5. Загрузка образа в локальное Registry
``` docker push 127.0.0.1:5000/custom-nginx:1.0.0 ```

![0500004 (Тэгирование)](https://github.com/user-attachments/assets/dda4c284-de5b-4655-9af9-36e4bc276b88)

Проверка:
``` curl http://127.0.0.1:5000/v2/_catalog ```

![0500005 (Проверка)](https://github.com/user-attachments/assets/8a9452ad-2f6e-471b-b912-6ce2398892fe)

5. Настройка Portainer

![0500006](https://github.com/user-attachments/assets/fde2a029-914a-471d-8ef8-1a3cef474f66)

![0500007](https://github.com/user-attachments/assets/f01014b5-a984-4f0c-b47a-0207f2ea07af)

![0500008](https://github.com/user-attachments/assets/9ba9d323-f94b-439b-a1aa-17a69a5652f1)

```
version: '3'
services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"

```

6. Inspect в Portainer

![0500009-1](https://github.com/user-attachments/assets/c198fdfc-760d-47fd-bb0f-fb3cdeeec277)

7. Удаление манифеста и предупреждение
```
rm compose.yaml
docker compose up -d
```

![05000010](https://github.com/user-attachments/assets/a21bba29-cd43-40e0-bc8c-0a1e577cf16e)

Docker Compose обнаружил "осиротевший" контейнер (portainer), который был создан из удаленного файла compose.yaml.

``` docker compose up -d --remove-orphans ```

![05000011](https://github.com/user-attachments/assets/c08b0ca8-8328-49f6-aa58-a41dd5197aff)

---
