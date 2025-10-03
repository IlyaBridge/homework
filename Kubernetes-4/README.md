#  «Домашнее задание к занятию» "`«Сетевое взаимодействие в Kubernetes»`" - `Казначеев Илья`

https://github.com/netology-code/kuber-homeworks/blob/shkuber-16/1.4/1.4.md

## Цель задания
Научиться настраивать доступ к приложениям в Kubernetes:
- Внутри кластера через Service (ClusterIP, NodePort).
- Снаружи кластера через Ingress.
Это задание поможет вам освоить базовые принципы сетевого взаимодействия в Kubernetes — ключевого навыка для работы с кластерами. На практике Service и Ingress используются для доступа к приложениям, балансировки нагрузки и маршрутизации трафика. Понимание этих механизмов поможет вам упростить управление сервисами в рабочих окружениях и снизит риски ошибок при развёртывании.

## Подготовка
Чеклист готовности
- Установлен Kubernetes (MicroK8S, Minikube или другой).
- Установлен kubectl.
- Редактор для YAML-файлов (VS Code, Vim и др.).

## Чеклист готовности к домашнему заданию
1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

Инструменты, которые пригодятся для выполнения задания
1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Инструкция](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download) по установке Minikube.
3. [Инструкция](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/) по установке kubectl.
4. [Инструкция](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools) по установке VS Code

Дополнительные материалы, которые пригодятся для выполнения задания
1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

## Задание 1: Настройка Service (ClusterIP и NodePort)
Задача
Развернуть приложение из двух контейнеров (nginx и multitool) и обеспечить доступ к ним:
- Внутри кластера через ClusterIP.
- Снаружи через NodePort.
Шаги выполнения
1. Создать Deployment с двумя контейнерами:
- nginx (порт 80).
- multitool (порт 8080).
- Количество реплик: 3.
2. Создать Service типа ClusterIP, который:
- Открывает nginx на порту 9001.
- Открывает multitool на порту 9002.
3. Проверить доступность изнутри кластера:
kubectl run test-pod --image=wbitt/network-multitool --rm -it -- sh
curl <service-name>:9001 # Проверить nginx
curl <service-name>:9002 # Проверить multitool

4. Создать Service типа NodePort для доступа к nginx снаружи.
5. Проверить доступ с локального компьютера:
curl <node-ip>:<node-port>
или через браузер.

Что сдать на проверку
- Манифесты:
deployment-multi-container.yaml
service-clusterip.yaml
service-nodeport.yaml
- Скриншоты проверки доступа (curl или браузер).

## Ответ 1

[Ссылка на Манифесты](https://github.com/IlyaBridge/homework/tree/main/Kubernetes-4/manifests)

![0001-6 Ответ](https://github.com/user-attachments/assets/119b6ca7-04e5-4a21-91bf-3c6042a9dec7)

![0001-7 ответ](https://github.com/user-attachments/assets/de80cf6c-d1df-4646-9acf-c156e752a4c6)

---

## Задание 2: Настройка Ingress
Задача
Развернуть два приложения (frontend и backend) и обеспечить доступ к ним через Ingress по разным путям.

Шаги выполнения
1. Развернуть два Deployment:
- frontend (образ nginx).
- backend (образ wbitt/network-multitool).
2. Создать Service для каждого приложения.
3. Включить Ingress-контроллер:
microk8s enable ingress
4. Создать Ingress, который:
- Открывает frontend по пути /.
- Открывает backend по пути /api.
5. Проверить доступность:
 curl <host>/
 curl <host>/api
или через браузер.

Что сдать на проверку
- Манифесты:
- deployment-frontend.yaml
- deployment-backend.yaml
- service-frontend.yaml
- service-backend.yaml
- ingress.yaml
- Скриншоты проверки доступа (curl или браузер).

Шаблоны манифестов с учебными комментариями
1. Deployment (nginx + multitool)
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: # ПРИМЕР: "multi-container-app"
spec:
  replicas: # ЗАДАНИЕ: Укажите количество реплик
  selector:
    matchLabels:
      app: # ДОПОЛНИТЕ: Метка для селектора
  template:
    metadata:
      labels:
        app: # ПОВТОРИТЕ метку из selector.matchLabels
    spec:
      containers:
 - name: # ЗАДАНИЕ: Название первого контейнера
        image: nginx
        ports:
 - containerPort: 80
 - name: multitool
        image: wbitt/network-multitool
        ports:
 - containerPort: 8080
        env:
 - name: HTTP_PORT
          value: "8080" # КЛЮЧЕВОЙ МОМЕНТ: Порт должен совпадать с containerPort
```

2. Ingress (для frontend и backend)
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: # ЗАДАНИЕ: Придумайте имя, допустим example-ingress
  annotations:  # ВАЖНО: Эта аннотация нужна для rewrite правил
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
 - http:
      paths:
 - path: /
        pathType: Prefix
        backend:
          service:
            name: # УКАЖИТЕ: Имя frontend Service
            port:
              number: 80
 - path: /api # КЛЮЧЕВОЙ ПУТЬ: API endpoint
        pathType: Prefix
        backend:
          service:
            name: # УКАЖИТЕ: Имя backend Service
            port:
              number: 80
```

## Ответ 2

[Ссылка на Манифесты](https://github.com/IlyaBridge/homework/tree/main/Kubernetes-4/manifests)

Проверка

![0002-8 (Финальная проверка)](https://github.com/user-attachments/assets/64f3f8ba-9ca2-495f-9205-c0d7c852fb81)

---
