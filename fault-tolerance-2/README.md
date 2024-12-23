![image](https://github.com/user-attachments/assets/3f42cc26-dcb6-4b7c-a8f9-d670bd223d46)# Домашнее задание к занятию "`Кластеризация и балансировка нагрузки`" - `Казначеев Илья`

### Цель задания
В результате выполнения этого задания вы научитесь:
1. Настраивать балансировку с помощью HAProxy
2. Настраивать связку HAProxy + Nginx

### Чеклист готовности к домашнему заданию
1. Установлена операционная система Ubuntu на виртуальную машину и имеется доступ к терминалу
2. Просмотрены конфигурационные файлы, рассматриваемые на лекции, которые находятся по ссылке https://github.com/netology-code/sflt-homeworks/tree/main/2

### Инструкция по выполнению домашнего задания

   1. Сделайте `fork` данного репозитория к себе в Github и переименуйте его по названию или номеру занятия, например, https://github.com/имя-вашего-репозитория/git-hw или  https://github.com/имя-вашего-репозитория/7-1-ansible-hw).
   2. Выполните клонирование данного репозитория к себе на ПК с помощью команды `git clone`.
   3. Выполните домашнее задание и заполните у себя локально этот файл README.md:
      - впишите вверху название занятия и вашу фамилию и имя
      - в каждом задании добавьте решение в требуемом виде (текст/код/скриншоты/ссылка)
      - для корректного добавления скриншотов воспользуйтесь [инструкцией "Как вставить скриншот в шаблон с решением](https://github.com/netology-code/sys-pattern-homework/blob/main/screen-instruction.md)
      - при оформлении используйте возможности языка разметки md (коротко об этом можно посмотреть в [инструкции  по MarkDown](https://github.com/netology-code/sys-pattern-homework/blob/main/md-instruction.md))
   4. После завершения работы над домашним заданием сделайте коммит (`git commit -m "comment"`) и отправьте его на Github (`git push origin`);
   5. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.
   6. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.
   
Желаем успехов в выполнении домашнего задания!
   
### Задание 1
1. Запустите два simple python сервера на своей виртуальной машине на разных портах
2. Установите и настройте HAProxy, воспользуйтесь материалами к лекции по ссылке https://github.com/netology-code/sflt-homeworks/tree/main/2
3. Настройте балансировку Round-robin на 4 уровне.
4. На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.

### Решение 1

Создадим два файла index.html в разных каталогах:
`$ sudo nano /home/ilya1/http1/index.html
$ sudo nano /home/ilya1/http2/index.html`
![image](https://github.com/user-attachments/assets/be19d905-452a-4aab-b8b5-c2e9e0cc4cb6)

Заполним файлы index.html содержимым из лекции:
Файл /http1/index.html:
`Server 1 Port 8888`
Файл /http2/index.html:
`Server 2 Port 9999`

Запустим сервера
Сервер №1:
`cd /http1
python3 -m http.server 8888`
Сервер №1:
`cd /http2
python3 -m http.server 9999`

Устаним HAProxy
`sudo apt update
sudo apt install haproxy`
![image](https://github.com/user-attachments/assets/57434edd-3cbe-48d0-ab01-3982cf919baf)

Убедимся, что конфигурация корректна:
`sudo haproxy -c -f /etc/haproxy/haproxy.cfg`
![image](https://github.com/user-attachments/assets/3d5f55b2-2a7a-422d-bfd3-dbf07aaf8e62)

Запуск HAProxy
`sudo systemctl start haproxy`
![image](https://github.com/user-attachments/assets/4b25aefb-9976-48d7-8937-4a8b0086ee5c)

Проверка работы HAProxy
Проверим статистики. Откроем веб-браузер и перейдём по адресу http://10.0.2.16:888/stats
![image](https://github.com/user-attachments/assets/569af41d-43b2-4e0b-a3fc-4c749bd64ceb)


Настроим файла конфигурации HAProxy  
файл haproxy.cfg
```
global
        log /dev/log        local0
        log /dev/log        local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
        log global
        mode http
        option httplog
        option dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

listen stats  # веб-страница со статистикой
        bind                    :888
        mode                    http
        stats                   enable
        stats uri               /stats
        stats refresh           5s
        stats realm             Haproxy\ Statistics

frontend example  # секция фронтенд
        mode http
        bind :8088
        #default_backend web_servers
        acl ACL_example.com hdr(host) -i example.com
        use_backend web_servers if ACL_example.com

backend web_servers    # секция бэкенд
        mode http
        balance roundrobin
        option httpchk
        http-check send meth GET uri /index.html
        server s1 127.0.0.1:8888 check
        server s2 127.0.0.1:9999 check

listen web_tcp
        bind :1325
        mode tcp
        balance roundrobin
        server s1 127.0.0.1:8888 check inter 3s
        server s2 127.0.0.1:9999 check inter 3s
```

Результат:
Сделаем проверку, когда работают сервер №1 и сервер №2
![image](https://github.com/user-attachments/assets/95ff9f32-94e6-440d-b091-03a5cc7fbb61)

Отключим сервер №1
![image](https://github.com/user-attachments/assets/db3d04a5-23d3-48bc-b635-bc5a7d7f4d85)

Проверим без сервера №1
![image](https://github.com/user-attachments/assets/e8f17901-ee14-43fa-992a-ca789b308d5e)

В целом проверка балансировки на 4 уровне: сервер №1 и сервер №2
![image](https://github.com/user-attachments/assets/b5eb0fed-7802-4d1a-a1f4-e7657ea72f6a)
![image](https://github.com/user-attachments/assets/920e1b05-f7a9-4fe9-9efe-fae9924f4d81)


---

### Задание 2
1. Запустите три simple python сервера на своей виртуальной машине на разных портах
2. Настройте балансировку Weighted Round Robin на 7 уровне, чтобы первый сервер имел вес 2, второй - 3, а третий - 4
3. HAproxy должен балансировать только тот http-трафик, который адресован домену example.local
4. На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy c использованием домена example.local и без него.

### Решение 1

Создадим третью директорию, для сервера №3, а также файл index.html:
`sudo nano /home/ilya1/http3/index.html`
Пропишем в файле index.html:
`Server 3 Port 7777`

Запустим сервера:
`python3 -m http.server 8888`
`python3 -m http.server 9999`
`python3 -m http.server 7777`

Отредактуем файл конфигурации HAProxy haproxy.cfg
```
global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

    # Настройка SSL
    ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
    ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
    ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000ms
    timeout client  50000ms
    timeout server  50000ms
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http

# Веб-страница со статистикой
listen stats
    bind :888
    mode http
    stats enable
    stats uri /stats
    stats refresh 5s
    stats realm Haproxy\ Statistics

# Frontend для обработки запросов
frontend example
    mode http
    bind :8088
    acl ACL_example.local hdr(host) -i example.local
    use_backend web_servers if ACL_example.local

# Backend с настройкой Weighted Round Robin
backend web_servers
    mode http
    balance roundrobin
    option httpchk
    http-check send meth GET uri /index.html
    server s1 127.0.0.1:8888 weight 2 check
    server s2 127.0.0.1:9999 weight 3 check
    server s3 127.0.0.1:7777 weight 4 check
```

Проверка работы 
Тестируем доступ через домен
`curl -H "Host: example.local" http://127.0.0.1:8088`
HAProxy будет балансировать запросы между серверами на портах 8888, 9999 и 7777 с учетом их весов.
![image](https://github.com/user-attachments/assets/76914ce3-bbf7-443b-8506-42a09e582942)

Тестируем без домена
Отправим запрос без заголовка Host:
`curl http://127.0.0.1:8088`
По умолчанию запросы не будут обработаны, так как они не соответствуют ACL для example.local.
![image](https://github.com/user-attachments/assets/539bad98-5228-4497-9eb1-0ea9176159b7)

Скриншоты работы серверов:
![image](https://github.com/user-attachments/assets/c4b221f4-37b9-4d5d-8968-2b50889c101c)

![image](https://github.com/user-attachments/assets/2a95a29c-bfa8-4459-bad6-db3d765b02dd)

![image](https://github.com/user-attachments/assets/70055c53-475c-4f35-a8ba-a091eed882c6)

Скриншот веб-страницы статистики HAProxy (http://127.0.0.1:888/stats):
![image](https://github.com/user-attachments/assets/dcbf2251-03b1-4f15-9dfc-db0c42e915ed)






