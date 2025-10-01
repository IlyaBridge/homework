#  «Домашнее задание к занятию» "`«Сетевое взаимодействие в K8S»`" - `Казначеев Илья`

https://github.com/netology-code/kuber-homeworks/blob/main/1.4/1.4.md

# ВНИМАНИЕ!!!
1. [Файлы решения Задания №1](https://github.com/IlyaBridge/homework/tree/main/Kubernetes-4/manifests/task1)
2. [Файлы решения Задания №2](https://github.com/IlyaBridge/homework/tree/main/Kubernetes-4/manifests/task2)

## Цель задания
В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

## Чеклист готовности к домашнему заданию
1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным Git-репозиторием.

## Инструменты и дополнительные материалы, которые пригодятся для выполнения задания
1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.


## Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера
1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
3. Создать отдельный Pod с приложением multitool и убедиться с помощью curl, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
4. Продемонстрировать доступ с помощью curl по доменному имени сервиса.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.


## Решение 1
Применяем Deployment
```
kubectl apply -f deployment-app.yaml
```
Ждем запуска Pod'ов
```
sleep 10
kubectl get pods -l app=nginx-multitool-app
```
Ждем полного запуска
```
kubectl wait --for=condition=ready pod -l app=nginx-multitool-app --timeout=180s
```
Проверяем результат
```
kubectl get pods -l app=nginx-multitool-app -o wide
```

![0001](https://github.com/user-attachments/assets/b0fa9ef2-4b42-455d-8dfd-30d053780eaf)

Применяем Service
```
kubectl apply -f service-clusterip.yaml
```
Проверяем Service
```
kubectl get service nginx-multitool-service
```
Проверяем Endpoints
```
kubectl get endpoints nginx-multitool-service
```
Детальная информация
```
kubectl describe service nginx-multitool-service
```
![0002](https://github.com/user-attachments/assets/d0df67a5-6aa9-4f60-a514-4f0335033a65)

# Применяем тестовый Pod
```
kubectl apply -f pod-test.yaml
```
Ждем запуска
```
kubectl wait --for=condition=ready pod/test-multitool --timeout=60s
```
Проверяем
```
kubectl get pod test-multitool
```
![0003](https://github.com/user-attachments/assets/66dfd59b-7274-4722-a725-8897cf7f9773)

## Тестирование доступа

Тест 1: Доступ к nginx через порт 9001
```
kubectl exec test-multitool -- curl -s http://nginx-multitool-service:9001 | head -10
```
![0004 Тест](https://github.com/user-attachments/assets/c7559016-ee09-45a9-9594-22db1cb313cc)

Тест 2: Доступ к multitool через порт 9002
```
kubectl exec test-multitool -- curl -s http://nginx-multitool-service:9002 | head -10
```
![0005 Тест](https://github.com/user-attachments/assets/d3369b66-b219-4bcc-900a-2e9f580f53a7)

Тест 3: Доступ по доменному имени
```
kubectl exec test-multitool -- curl -s http://nginx-multitool-service.default.svc.cluster.local:9001 | head -5
kubectl exec test-multitool -- curl -s http://nginx-multitool-service.default.svc.cluster.local:9002 | head -5
```
![0006 Тест](https://github.com/user-attachments/assets/04ccd753-54f1-43a7-a5fa-20395e26c62d)

Проверка DNS
```
kubectl exec test-multitool -- nslookup nginx-multitool-service
```
![0007 Тест](https://github.com/user-attachments/assets/ef5ed8a4-53a0-49dc-b9c7-4f26487db02d)

Демонстрация балансировки нагрузки
```
for i in {1..3}; do
  kubectl exec test-multitool -- curl -s http://nginx-multitool-service:9002 | \
    grep -o "nginx-multitool-app-[^-]*-[^-]*" | head -1
done
```
![0008 Тест балансировщик](https://github.com/user-attachments/assets/f0a0b7b7-8290-41dd-8da1-d579b9bcfa2c)

Финальная проверка
```
kubectl get all -l app=nginx-multitool-app
```
![0009 Тест Финал](https://github.com/user-attachments/assets/b4bc3300-d0cb-4335-a25f-bfef216d1ed8)

---

## Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера
1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или curl с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

## Решение 2
Применяем NodePort Service
```
kubectl apply -f service-nodeport.yaml
```
Проверяем создание Service
```
kubectl get service nginx-nodeport-service
```
Детальная информация о Service
```
kubectl describe service nginx-nodeport-service
```
![0002-1](https://github.com/user-attachments/assets/32e3b33e-0f58-4017-af40-9d4e23b64b20)

Получаем InternalIP ноды
```
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "Node Internal IP: $NODE_IP"
```
![0002-2](https://github.com/user-attachments/assets/d0d72414-ffd0-4c4d-9189-8a2caad9f61e)

## Тестирование внешнего доступа
Определяем IP для тестирования
if [ -n "$EXTERNAL_IP" ]; then
    TEST_IP=$EXTERNAL_IP
elif [ -n "$NODE_IP" ]; then
    TEST_IP=$NODE_IP
else
    TEST_IP=$HOST_IP
fi

echo "Используемый IP: $TEST_IP"
![0002-3](https://github.com/user-attachments/assets/436f9ff5-e282-46f8-b498-92ad77f4b0bf)

Тест 1: Простой curl запрос
```
curl -s http://$TEST_IP:30080 | head -10
```
![0002-4](https://github.com/user-attachments/assets/6e5b22ed-8a05-415d-a421-0a4554b133fe)

Тест 2: Проверка с подробным выводом
```
curl -v http://$TEST_IP:30080 2>&1 | head -20
```
![0002-5](https://github.com/user-attachments/assets/ad810bdf-127c-4a2b-a2be-2fcdba1cc096)

Тест 3: Проверка нескольких запросов для демонстрации балансировки
```
for i in {1..3}; do
  curl -s http://10.0.2.15:30080 | grep -q "Welcome to nginx" && \
  echo "Запрос $i успешен" || echo "Запрос $i не удался"
done
```
![0002-6 балансировщик](https://github.com/user-attachments/assets/83fe1a35-23ec-46f3-89a6-10c7e7d2f8e3)

### Проверка через браузер (демонстрация)
Запускаем port-forward для демонстрации в браузере
```
kubectl port-forward service/nginx-nodeport-service 8080:80 --address 0.0.0.0 &
```

Проверяем в браузере: 
http://localhost:8080
![0002-7 Итоговый ответ](https://github.com/user-attachments/assets/2a8c608b-8ff6-4d8b-8418-06e2485fcb6d)

http://10.0.2.15.:30080
![0002-8 Итоговый ответ](https://github.com/user-attachments/assets/81ba05e8-e047-4e8f-a0f0-3641cfe28ca3)

---
