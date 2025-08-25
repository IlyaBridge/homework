#  «Создание собственных модулей» "`«Система сбора логов Elastic Stack»`" - `Казначеев Илья`

https://github.com/netology-code/mnt-homeworks/tree/MNT-video/10-monitoring-04-elk

---

## Задание 1
Вам необходимо поднять в докере и связать между собой:
•	elasticsearch (hot и warm ноды);
•	logstash;
•	kibana;
•	filebeat.
Logstash следует сконфигурировать для приёма по tcp json-сообщений.
Filebeat следует сконфигурировать для отправки логов docker вашей системы в logstash.
В директории help находится манифест docker-compose и конфигурации filebeat/logstash для быстрого выполнения этого задания.
Результатом выполнения задания должны быть:
•	скриншот docker ps через 5 минут после старта всех контейнеров (их должно быть 5);
•	скриншот интерфейса kibana;
•	docker-compose манифест (если вы не использовали директорию help);
•	ваши yml-конфигурации для стека (если вы не использовали директорию help).

## Решение 1

![0001 Ответ 1 Задание 1 (docker ps)](https://github.com/user-attachments/assets/0292d0e6-92a6-4b83-864e-ad067152babf)

![0002 Ответ 1 Задание 1 (docker ps)](https://github.com/user-attachments/assets/1cdf21cc-fec2-42aa-a9ae-be82f8e9bd04)

![0003 Ответ 2 Задание 1 (Kibana)](https://github.com/user-attachments/assets/13ad6b7a-2ec2-4b7a-8d2c-0b1ecd39724b)

![0004 Ответ 2 Задание 1 (Kibana)](https://github.com/user-attachments/assets/4b7bb840-f966-43e9-a8d9-87313a397acd)

![0006 Ответ 3 Задание 1 (Проверяем подключение к Elasticsearch)](https://github.com/user-attachments/assets/bb4560bb-1fc7-41ee-918f-1453906bef0a)

---

## Задание 2
Перейдите в меню создания index-patterns в kibana и создайте несколько index-patterns из имеющихся.
Перейдите в меню просмотра логов в kibana (Discover) и самостоятельно изучите, как отображаются логи и как производить поиск по логам.
В манифесте директории help также приведенно dummy-приложение, которое генерирует рандомные события в stdout-контейнера. Эти логи должны порождать индекс logstash-* в elasticsearch. Если этого индекса нет — воспользуйтесь советами и источниками из раздела «Дополнительные ссылки» этого задания.

## Решение 2

![01](https://github.com/user-attachments/assets/852e116c-e597-4416-873c-5f889945d009)

---
