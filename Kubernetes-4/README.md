#  «Домашнее задание к занятию» "`«Сетевое взаимодействие в K8S»`" - `Казначеев Илья`

https://github.com/netology-code/kuber-homeworks/blob/main/1.4/1.4.md

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

[0001]

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

[0002]

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

[0003]

## Тестирование доступа

Тест 1: Доступ к nginx через порт 9001
```
kubectl exec test-multitool -- curl -s http://nginx-multitool-service:9001 | head -10
```

[0004 Тест]

Тест 2: Доступ к multitool через порт 9002
```
kubectl exec test-multitool -- curl -s http://nginx-multitool-service:9002 | head -10
```

[0005 Тест]

Тест 3: Доступ по доменному имени
```
kubectl exec test-multitool -- curl -s http://nginx-multitool-service.default.svc.cluster.local:9001 | head -5
kubectl exec test-multitool -- curl -s http://nginx-multitool-service.default.svc.cluster.local:9002 | head -5
```

[0006 Тест]


Проверка DNS
```
kubectl exec test-multitool -- nslookup nginx-multitool-service
```
[0007 Тест]

Демонстрация балансировки нагрузки
```
for i in {1..3}; do
  echo "Запрос $i к nginx:"
  kubectl exec test-multitool -- curl -s http://nginx-multitool-service:9001 | grep -o "Welcome to nginx" || echo "Успешный ответ от nginx"
done
```

[0008 Тест]

Финальная проверка
```
kubectl get all -l app=nginx-multitool-app
```

[0009 Тест]

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

[0002-1]

Получаем InternalIP ноды
```
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "Node Internal IP: $NODE_IP"
```

[0002-2]

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

[0002-3]

Тест 1: Простой curl запрос
```
curl -s http://$TEST_IP:30080 | head -10
```

[0002-4]

Тест 2: Проверка с подробным выводом
```
curl -v http://$TEST_IP:30080 2>&1 | head -20
```

[0002-5]

Тест 3: Проверка нескольких запросов для демонстрации балансировки
```
for i in {1..3}; do
    echo "Запрос $i:"
    curl -s http://$TEST_IP:30080 | grep -o "Welcome to nginx" || \
    curl -s http://$TEST_IP:30080 | grep -o "WBITT Network MultiTool" || \
    echo "Успешный ответ"
    echo "---"
done
```
[0002-6]

### Проверка через браузер (демонстрация)
Запускаем port-forward для демонстрации в браузере
```
kubectl port-forward service/nginx-nodeport-service 8080:80 --address 0.0.0.0 &
```

Проверяем в браузере: 
http://localhost:8080

[0002-7]

http://10.0.2.15.:30080

[0002-8]

---
