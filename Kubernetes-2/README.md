#  «Домашнее задание к занятию» "`«Базовые объекты K8S»`" - `Казначеев Илья`

https://github.com/netology-code/kuber-homeworks/blob/main/1.2/1.2.md

## Цель задания
В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера.

## Чеклист готовности к домашнему заданию
1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным Git-репозиторием.

## Инструменты и дополнительные материалы, которые пригодятся для выполнения задания
1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

## Задание 1. Создать Pod с именем hello-world
Создать манифест (yaml-конфигурацию) Pod.
Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
Подключиться локально к Pod с помощью kubectl port-forward и вывести значение (curl или в браузере).

## Решение 1

файл: pod-hello-world.yaml

```
apiVersion: v1
kind: Pod
metadata:
  name: hello-world
  labels:
    app: hello-world
spec:
  containers:
  - name: echoserver
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    ports:
    - containerPort: 8080
    env:
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: POD_NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
    - name: POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
```

Применяем манифест^
```
kubectl apply -f pod-hello-world.yaml
```
![001 - Задание 1](https://github.com/user-attachments/assets/05c1b0a6-e6cf-4c49-bd32-f777d6b9780d)

Проверяем создание Pod:
```
kubectl get pods -o wide
```
![002 - Задание 1](https://github.com/user-attachments/assets/e9691635-aec6-4895-8824-fbdaf83f6f0f)

```
kubectl describe pod hello-world
```
![003 - Задание 1](https://github.com/user-attachments/assets/4a7a0699-7d36-48f6-b440-c033283b4b62)

Подключаемся к Pod через port-forward

```
kubectl port-forward pod/hello-world 8080:8080 --address 0.0.0.0 &
```
```
curl http://localhost:8080
```
![005 - Задание 1](https://github.com/user-attachments/assets/3a75fc68-014c-4045-8760-e8ecd8698897)

```
http://localhost:8080
```
![006 - Задание 1](https://github.com/user-attachments/assets/592b4ece-129c-4b44-bd95-1857b3e51521)

---

## Задание 2. Создать Service и подключить его к Pod
Создать Pod с именем netology-web.
Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
Создать Service с именем netology-svc и подключить к netology-web.
Подключиться локально к Service с помощью kubectl port-forward и вывести значение (curl или в браузере).

## Решение 2

pod-netology-web.yaml

```
apiVersion: v1
kind: Pod
metadata:
  name: netology-web
  labels:
    app: netology-web
spec:
  containers:
  - name: echoserver
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    ports:
    - containerPort: 8080
```

service-netology-svc.yaml

```
apiVersion: v1
kind: Service
metadata:
  name: netology-svc
spec:
  selector:
    app: netology-web
  ports:
  - name: http
    port: 80
    targetPort: 8080
  type: ClusterIP
```

Применяем манифесты
```
kubectl apply -f pod-netology-web.yaml
kubectl apply -f service-netology-svc.yaml
```
![007 - Задание 2](https://github.com/user-attachments/assets/6408f484-e910-4594-8e40-b2106bea6653)


Проверяем создание ресурсов
```
kubectl get pods -o wide
```
![008 - Задание 2](https://github.com/user-attachments/assets/adeff169-761e-4c67-90a7-622f7c3b2d35)

```
kubectl get services -o wide
```
![009 - Задание 2](https://github.com/user-attachments/assets/6fb1b4cf-f16f-41a6-ac49-a4a75dc32fa4)

```
kubectl describe service netology-svc
```
![010 - Задание 2](https://github.com/user-attachments/assets/21c67843-6c5e-47ac-864f-579ac12386e1)

Подключаемся к Service через port-forward
```
kubectl port-forward service/netology-svc 8081:80 --address 0.0.0.0 &
```
![011 - Задание 2](https://github.com/user-attachments/assets/1f0d48e2-8a3d-4021-b464-b454c813a61b)

```
http://localhost:8081
```
![012 - Задание 2](https://github.com/user-attachments/assets/e48ef965-3180-4249-b4e8-07dd3b18bdd0)

---
