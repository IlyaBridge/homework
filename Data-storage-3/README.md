# Домашнее задание к занятию "`ELK`" - `Казначеев Илья`

### Задание 1. Elasticsearch
Установите и запустите Elasticsearch, после чего поменяйте параметр cluster_name на случайный.
Приведите скриншот команды 'curl -X GET 'localhost:9200/_cluster/health?pretty', сделанной на сервере с установленным Elasticsearch. Где будет виден нестандартный cluster_name.

### Решение 1. Elasticsearch

![image](https://github.com/user-attachments/assets/b157357a-805a-4c03-ba3d-b11f8780feda)

![image](https://github.com/user-attachments/assets/93146b02-231a-447a-879d-dd3896f13e51)

---

### Задание 2. Kibana
Установите и запустите Kibana.
Приведите скриншот интерфейса Kibana на странице http://<ip вашего сервера>:5601/app/dev_tools#/console, где будет выполнен запрос GET /_cluster/health?pretty.

### Решение 2. Kibana

![image](https://github.com/user-attachments/assets/17bf45c9-ba64-48e9-a143-5a51e7e3e1f3)

---

### Задание 3. Logstash
Установите и запустите Logstash и Nginx. С помощью Logstash отправьте access-лог Nginx в Elasticsearch.
Приведите скриншот интерфейса Kibana, на котором видны логи Nginx.

### Решение 3. Logstash

![image](https://github.com/user-attachments/assets/25d7b8f4-4f8c-4c1d-8575-1b582fb2b889)

---

### Задание 4. Filebeat
Установите и запустите Filebeat. Переключите поставку логов Nginx с Logstash на Filebeat.
Приведите скриншот интерфейса Kibana, на котором видны логи Nginx, которые были отправлены через Filebeat.

### Решение 4. Filebeat

![image](https://github.com/user-attachments/assets/938542fa-c997-4db2-80e7-f6e912f5407a)

---
