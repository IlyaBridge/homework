# Домашнее задание к занятию "`Disaster recovery и Keepalived`" - `Казначеев Илья`


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
   
### Дополнительные материалы, которые могут быть полезны для выполнения задания

1. [Руководство по оформлению Markdown файлов](https://gist.github.com/Jekins/2bf2d0638163f1294637#Code)

---

### Задание 1
•	Дана схема для Cisco Packet Tracer, рассматриваемая в лекции.
•	На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы) 
https://github.com/netology-code/sflt-homeworks/blob/main/1/hsrp_advanced.pkt
•	Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
•	Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
•	На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.

### Решение 1

![001-1 - router1](https://github.com/user-attachments/assets/1ac30fd7-60cc-451c-ab72-3037abe01797)

![001-2 - router2](https://github.com/user-attachments/assets/ad9c8f1b-9308-412c-a646-04308addaa0d)

![001-3](https://github.com/user-attachments/assets/e1af5b15-7106-4ec5-9097-53ccf37074dc)

---

### Задание 2
1. Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного файла.
https://github.com/netology-code/sflt-homeworks/blob/main/1/keepalived-simple.conf
2. Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
3. Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
4. Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
5. На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

### Решение 1

1. `Конфигурация Keepalived на сервере 1 (MASTER)`
   /etc/keepalived/keepalived.conf
```
vrrp_script check_nginx {
    script "/usr/local/bin/check_nginx.sh"
    interval 3
    weight -20
}

vrrp_instance VI_1 {
    state MASTER
    interface enp0s3
    virtual_router_id 10
    priority 255
    advert_int 1

    virtual_ipaddress {
        10.0.2.10/24
    }

    track_script {
        check_nginx
    }
}

```

2. `Конфигурация Keepalived на сервере 2 (BACKUP)`
   /etc/keepalived/keepalived.conf
```
vrrp_script check_nginx {
    script "/usr/local/bin/check_nginx.sh"
    interval 3
    weight -20
}

vrrp_instance VI_1 {
    state BACKUP
    interface enp0s3
    virtual_router_id 10
    priority 200
    advert_int 1

    virtual_ipaddress {
        10.0.2.10/24
    }

    track_script {
        check_nginx
    }
}

```

4. `Bash-скрипт, создаётся на сервере №1 и сервере №2`
   /usr/local/bin/check_nginx.sh
```
#!/bin/bash

PORT=80
INDEX_FILE="/var/www/html/index.html"

# Проверка доступности порта
if ! nc -z localhost $PORT; then
    echo "Port $PORT is not available"
    exit 1
fi

# Проверка наличия файла index.html
if [ ! -f "$INDEX_FILE" ]; then
    echo "File $INDEX_FILE does not exist"
    exit 1
fi

exit 0

```
Результат:
![image](https://github.com/user-attachments/assets/487da52f-2ef6-4b13-adb2-b7fcdc0fd8f6)




