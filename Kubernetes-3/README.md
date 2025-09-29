#  «Домашнее задание к занятию» "`«Запуск приложений в K8S»`" - `Казначеев Илья`

https://github.com/netology-code/kuber-homeworks/blob/main/1.3/1.3.md

## Цель задания
В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

## Чеклист готовности к домашнему заданию
1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.


## Инструменты и дополнительные материалы, которые пригодятся для выполнения задания
1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

---

## Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod
1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
5. Создать отдельный Pod с приложением multitool и убедиться с помощью curl, что из пода есть доступ до приложений из п.1.


## Решение 1
## 1.1. Создание Deployment с двумя контейнерами

### Создаем манифест Deployment
Файл deployment-nginx-multitool.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool
  labels:
    app: nginx-multitool
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-multitool
  template:
    metadata:
      labels:
        app: nginx-multitool
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
      
      - name: multitool
        image: wbitt/network-multitool:latest
        ports:
        - containerPort: 80
        env:
        - name: HTTP_PORT
          value: "80"
        - name: HTTPS_PORT
          value: "443"
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
```
Здесь мы создаем Deployment с именем nginx-multitool. Используем 2 контейнера: nginx и multitool. Оба контейнера слушают порт 80

## 1.2. Применение Deployment и решение ошибок
Применяем манифест и наблюдаем ошибку:
### Применяем манифест
kubectl apply -f deployment-nginx-multitool.yaml

скриншот 3

### Проверяем статус Pod
kubectl get pods -l app=nginx-multitool

скриншот 4

### Смотрим детали для выявления ошибки
kubectl describe pod -l app=nginx-multitool

скриншот 5

Ошибка будет где оба контейнера пытаются занять порт 80, что вызывает конфликт.

### Создаем исправленную версию манифеста
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool
  labels:
    app: nginx-multitool
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-multitool
  template:
    metadata:
      labels:
        app: nginx-multitool
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
      
      - name: multitool
        image: wbitt/network-multitool:latest
        ports:
        - containerPort: 8080
        env:
        - name: HTTP_PORT
          value: "8080"
        - name: HTTPS_PORT
          value: "8443"
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
```

### Применяем исправленную версию
kubectl apply -f deployment-nginx-multitool-fixed.yaml

скриншот 6

### Проверяем, что Pod запустился
kubectl get pods -l app=nginx-multitool

скриншот 7

## 1.3. Масштабирование Deployment
Демонстрируем количество подов до масштабирования:
### Проверяем текущее количество реплик
kubectl get deployment nginx-multitool

скриншот 8
 
### Смотрим текущие Pod'ы
kubectl get pods -l app=nginx-multitool -o wide

скриншот 9

## Масштабируем до 2 реплик:
### Масштабируем Deployment
kubectl scale deployment nginx-multitool --replicas=2

скриншот 11

### Проверяем результат масштабирования
kubectl get deployment nginx-multitool

скриншот 12

### Смотрим новые Pod'ы
kubectl get pods -l app=nginx-multitool -o wide

скриншот 13

## 1.4. Создание Service для доступа к приложению
Создаем манифест Service:
Файл service-nginx-multitool.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-multitool-service
  labels:
    app: nginx-multitool
spec:
  selector:
    app: nginx-multitool
  ports:
  - name: nginx
    port: 80
    targetPort: 80
    protocol: TCP
  - name: multitool
    port: 8080
    targetPort: 8080
    protocol: TCP
  type: ClusterIP
```

### Применяем Service
kubectl apply -f service-nginx-multitool.yaml

скриншот 15

### Проверяем создание Service
kubectl get service nginx-multitool-service

скриншот 16

### Смотрим детали Service
kubectl describe service nginx-multitool-service

скриншот 17

## 1.5. Создание отдельного Pod для тестирования доступа

Файл pod-test-multitool.yaml
```
apiVersion: v1
kind: Pod
metadata:
  name: test-multitool
  labels:
    app: test-multitool
spec:
  containers:
  - name: multitool
    image: wbitt/network-multitool:latest
    command: ["sleep"]
    args: ["infinity"]
  restartPolicy: Never
```

### Создаем тестовый Pod
kubectl apply -f pod-test-multitool.yaml

скриншот 18

### Ждем запуска Pod
kubectl wait --for=condition=ready pod/test-multitool --timeout=60s

скриншот 19

### Тестируем доступ к nginx контейнерам через Service
kubectl exec test-multitool -- curl -s http://nginx-multitool-service:80

скриншот 20
 
### Тестируем доступ к multitool контейнерам через Service  
kubectl exec test-multitool -- curl -s http://nginx-multitool-service:8080

скриншот 21
 
### Тестируем доступ к отдельным Pod'ам
kubectl get pods -l app=nginx-multitool -o wide

скриншот 22
 
### Тестируем прямой доступ к Pod
kubectl exec test-multitool -- curl -s http://$POD_IP:80

скриншот 23
 
kubectl exec test-multitool -- curl -s http://$POD_IP:8080

скриншот 24

---

## Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий
1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.


## Решение 2
### Создаем манифест
Файл deployment-nginx-init.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-init
  labels:
    app: nginx-init
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-init
  template:
    metadata:
      labels:
        app: nginx-init
    spec:
      initContainers:
      - name: check-service
        image: busybox:1.35
        command: ['sh', '-c', 'until nslookup nginx-init-service.default.svc.cluster.local; do echo "waiting for service"; sleep 2; done; echo "Service found!"']
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
```

### Создаем Deployment (без Service)
      kubectl apply -f deployment-nginx-init.yaml
### Проверяем состояние Pod - должен ЗАВИСНУТЬ в Init
      kubectl get pods -l app=nginx-init

скриншот 2-1

### Смотрим детали - должен быть Init:0/1
kubectl describe pod -l app=nginx-init

скриншот 2-2

## Проверяем, что Init-контейнер ЗАВИС

### Смотрим логи init-контейнера
kubectl logs -l app=nginx-init -c check-service

скриншот 2-4

## Создаем Service
### Создаем Service
Файл service-nginx-init.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-init-service
  labels:
    app: nginx-init
spec:
  selector:
    app: nginx-init
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
  type: ClusterIP

### Применяем Service
kubectl apply -f service-nginx-init.yaml
### Проверяем создание Service
kubectl get service nginx-init-service

скриншот 2-6

## Наблюдаем успешный запуск
### В реальном времени наблюдаем за Pod
kubectl get pods -l app=nginx-init -w

скриншот 2-7

### В другом терминале наблюдаем логи init-контейнера
kubectl logs -l app=nginx-init -c check-service -f

скриншот 2-8

## Финальная проверка
### После успешного запуска проверяем
kubectl get pods -l app=nginx-init

скриншот 2-9

### Смотрим логи nginx
kubectl logs -l app=nginx-init -c nginx

скриншот 2-10

### Тестируем
kubectl port-forward deployment/nginx-init 8080:80 &
curl http://localhost:8080
pkill -f "port-forward"

скриншот 2-11

---

## Правила приёма работы
1.	Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2.	Файл README.md должен содержать скриншоты вывода команд kubectl get pods, а также скриншот результата подключения.
3.	Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

---