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

Проверяем создание Pod:

```
kubectl get pods -o wide
```

```
kubectl describe pod hello-world
```

Подключаемся к Pod через port-forward

```
kubectl port-forward pod/hello-world 8080:8080 --address 0.0.0.0 &
```
```
curl http://localhost:8080
```

[скриншот]

http://localhost:808


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

Проверяем создание ресурсов

```
kubectl get pods -o wide
```

```
kubectl get services -o wide
```

```
kubectl describe service netology-svc
```

Подключаемся к Service через port-forward

```
kubectl port-forward service/netology-svc 8081:80 --address 0.0.0.0 &
```

http://localhost:8081



---
