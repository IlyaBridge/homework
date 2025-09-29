#  «Домашнее задание к занятию» "`«Запуск приложений в K8S»`" - `Казначеев Илья`

https://github.com/netology-code/kuber-homeworks/blob/main/1.3/1.3.md

# ВНИМАНИЕ!!!
1. [Файлы решения Задания №1](https://github.com/IlyaBridge/homework/tree/main/Kubernetes-3/manifests/task1)
2. [Файлы решения Задания №2](https://github.com/IlyaBridge/homework/tree/main/Kubernetes-3/manifests/task2)

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

![0003](https://github.com/user-attachments/assets/68292157-1deb-41d9-a682-6f5698717105)

### Проверяем статус Pod
kubectl get pods -l app=nginx-multitool

![0004](https://github.com/user-attachments/assets/7324fe99-ff62-4207-9083-e2add14a8413)

### Смотрим детали для выявления ошибки
kubectl describe pod -l app=nginx-multitool

![0005](https://github.com/user-attachments/assets/f4024e92-e466-4d56-90f2-943cf8660b73)

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

![0006](https://github.com/user-attachments/assets/bd229041-faaf-464f-957f-585616fc94f4)

### Проверяем, что Pod запустился
kubectl get pods -l app=nginx-multitool

![0007](https://github.com/user-attachments/assets/274d6991-5e6f-4356-8451-e45d84380af9)

## 1.3. Масштабирование Deployment
Демонстрируем количество подов до масштабирования:
### Проверяем текущее количество реплик
kubectl get deployment nginx-multitool

![0008](https://github.com/user-attachments/assets/7efacef9-4b9d-4f11-b293-08abf05fe0ed)

### Смотрим текущие Pod'ы
kubectl get pods -l app=nginx-multitool -o wide

![0009](https://github.com/user-attachments/assets/0618035a-6adf-4994-9b89-26e00939c936)

## Масштабируем до 2 реплик:
### Масштабируем Deployment
kubectl scale deployment nginx-multitool --replicas=2

![0011](https://github.com/user-attachments/assets/9fb2594d-0c3d-4c7c-8eee-d8fd250a23bf)

### Проверяем результат масштабирования
kubectl get deployment nginx-multitool

![0012](https://github.com/user-attachments/assets/06040fb0-0725-4edd-8775-6d8c5e65d45e)

### Смотрим новые Pod'ы
kubectl get pods -l app=nginx-multitool -o wide

![0013](https://github.com/user-attachments/assets/0fef6802-f9c9-46ae-94e9-1a4c6319573d)

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

![0015](https://github.com/user-attachments/assets/4c1b9c65-8a64-4513-826a-584c6e991fcb)

### Проверяем создание Service
kubectl get service nginx-multitool-service

![0016](https://github.com/user-attachments/assets/6b5e6383-bdb0-411e-9b9a-f55fbf88694e)

### Смотрим детали Service
kubectl describe service nginx-multitool-service

![0017](https://github.com/user-attachments/assets/563fa2eb-2f4e-46e8-a3e5-da7b8d83dc89)

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

![0018](https://github.com/user-attachments/assets/04fb3df9-2e34-4c3e-b64c-a3af3818de00)

### Ждем запуска Pod
kubectl wait --for=condition=ready pod/test-multitool --timeout=60s

![0019](https://github.com/user-attachments/assets/35d26925-36d1-49c7-b967-24ad33caa464)

### Тестируем доступ к nginx контейнерам через Service
kubectl exec test-multitool -- curl -s http://nginx-multitool-service:80

![0020](https://github.com/user-attachments/assets/0536e90c-80f9-493c-80fb-b4268c79f201)

### Тестируем доступ к multitool контейнерам через Service  
kubectl exec test-multitool -- curl -s http://nginx-multitool-service:8080

![0021](https://github.com/user-attachments/assets/475de3a1-6f59-491c-9eca-96f3b8800df6)
 
### Тестируем доступ к отдельным Pod'ам
kubectl get pods -l app=nginx-multitool -o wide

![0022](https://github.com/user-attachments/assets/5b0c9d4a-58bd-49c1-a261-5aede277a6a0)

### Тестируем прямой доступ к Pod
kubectl exec test-multitool -- curl -s http://$POD_IP:80

![0023](https://github.com/user-attachments/assets/3756a88c-da34-4faf-aaf3-b9f99eca8e45)

kubectl exec test-multitool -- curl -s http://$POD_IP:8080

![0024](https://github.com/user-attachments/assets/1e614185-8ab3-459d-aa50-854984a1c6c3)

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

![0002-1](https://github.com/user-attachments/assets/5f0c1ba7-b51c-4cd5-a991-b268dad9f63e)

### Смотрим детали - должен быть Init:0/1
kubectl describe pod -l app=nginx-init

![0002-2](https://github.com/user-attachments/assets/aa65a9da-e55a-4a2a-a35b-aed849438bb5)

## Проверяем, что Init-контейнер ЗАВИС

### Смотрим логи init-контейнера
kubectl logs -l app=nginx-init -c check-service

![0002-4](https://github.com/user-attachments/assets/e1f0b41e-5ba1-4ad1-a18a-f1a7dae57539)

## Создаем Service
### Создаем Service
Файл service-nginx-init.yaml
```
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
```

### Применяем Service
kubectl apply -f service-nginx-init.yaml
### Проверяем создание Service
kubectl get service nginx-init-service

![0002-6](https://github.com/user-attachments/assets/0e50075c-db54-4366-ad20-2457409c2d28)

## Наблюдаем успешный запуск
### В реальном времени наблюдаем за Pod
kubectl get pods -l app=nginx-init -w

![0002-7](https://github.com/user-attachments/assets/6e9efe39-93bb-437c-b61a-ed45aed87e76)

### В другом терминале наблюдаем логи init-контейнера
kubectl logs -l app=nginx-init -c check-service -f

![0002-8](https://github.com/user-attachments/assets/0aa82370-59e5-4bed-812d-aec3f18c5594)

## Финальная проверка
### После успешного запуска проверяем
kubectl get pods -l app=nginx-init

![0002-9](https://github.com/user-attachments/assets/89d6975e-169c-4ad0-aba5-7edb05aa6fd2)

### Смотрим логи nginx
kubectl logs -l app=nginx-init -c nginx

![0002-10](https://github.com/user-attachments/assets/28745d81-9847-40f4-81a9-dece1979cb0b)

### Тестируем
kubectl port-forward deployment/nginx-init 8080:80 &
curl http://localhost:8080
pkill -f "port-forward"

![0002-11](https://github.com/user-attachments/assets/8a91f4e7-28cc-45ae-be88-2d5092edbc12)

---

## Правила приёма работы
1.	Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2.	Файл README.md должен содержать скриншоты вывода команд kubectl get pods, а также скриншот результата подключения.
3.	Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

---
