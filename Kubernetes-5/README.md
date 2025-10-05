#  «Домашнее задание к занятию» "`«Хранение в K8s»`" - `Казначеев Илья`

https://github.com/netology-code/kuber-homeworks/blob/shkuber-16/2.1/2.1.md

Примерное время выполнения задания — 180 минут

## Цель задания
Научиться работать с хранилищами в тестовой среде Kubernetes:

обеспечить обмен файлами между контейнерами пода;
создавать PersistentVolume (PV) и использовать его в подах через PersistentVolumeClaim (PVC);
объявлять свой StorageClass (SC) и монтировать его в под через PVC.
Это задание поможет вам освоить базовые принципы взаимодействия с хранилищами в Kubernetes — одного из ключевых навыков для работы с кластерами. На практике Volume, PV, PVC используются для хранения данных независимо от пода, обмена данными между подами и контейнерами внутри пода. Понимание этих механизмов поможет вам упростить проектирование слоя данных для приложений, разворачиваемых в кластере k8s.


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

## Задание 1: Volume: обмен данными между контейнерами в поде
Задача
Создать Deployment приложения, состоящего из двух контейнеров, обменивающихся данными.

Шаги выполнения
Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
Настроить busybox на запись данных каждые 5 секунд в некий файл в общей директории.
Обеспечить возможность чтения файла контейнером multitool.
Что сдать на проверку
Манифесты:
containers-data-exchange.yaml
Скриншоты:
описание пода с контейнерами (kubectl describe pods data-exchange)
вывод команды чтения файла (tail -f <имя общего файла>)

## Ответ 1

[Cсылка на манифест](https://github.com/IlyaBridge/homework/tree/main/Kubernetes-5/task-1/manifests)

Описание пода с контейнерами

![0001-2 (Ответ)](https://github.com/user-attachments/assets/92a9ce7f-0a57-4a6b-8666-d6430b7b1264)

Вывод команды чтения файла:
```
kubectl logs -l app=data-exchange -c multitool --tail=20
```

![0001-3 (Ответ)](https://github.com/user-attachments/assets/4213499a-73c4-440a-83ed-d0d9c998aa03)

---

## Задание 2: PV, PVC 
Задача
Создать Deployment приложения, использующего локальный PV, созданный вручную.

Шаги выполнения
Создать Deployment приложения, состоящего из контейнеров busybox и multitool, использующего созданный ранее PVC
Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
Продемонстрировать, что контейнер multitool может читать данные из файла в смонтированной директории, в который busybox записывает данные каждые 5 секунд.
Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему. (Используйте команду kubectl describe pv).
Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV. Продемонстрировать, что произошло с файлом после удаления PV. Пояснить, почему.

Что сдать на проверку
- Манифесты:
pv-pvc.yaml
- Скриншоты:
каждый шаг выполнения задания, начиная с шага 2.
- Описания:
объяснение наблюдаемого поведения ресурсов в двух последних шагах.

## Ответ 2

[Cсылка на манифест](https://github.com/IlyaBridge/homework/tree/main/Kubernetes-5/task-2/manifests)

Запускаем под, перед этим запускаем манифест и проверяем создание ресурсов:

![0002-1](https://github.com/user-attachments/assets/3421cb4b-150d-4114-ac1a-6b4e7b5e518f)

Получаем имя пода
```
POD_NAME=$(kubectl get pods -l app=data-exchange-pv -o jsonpath='{.items[0].metadata.name}')
echo "Pod: $POD_NAME"
```

![0002-3](https://github.com/user-attachments/assets/b7e9dc8d-b87d-49cd-abae-15dc1e8506a5)

Проверяем что multitool читает данные из PV
```
kubectl logs $POD_NAME -c multitool --tail=10
```

![0002-4](https://github.com/user-attachments/assets/c3b381cb-27c2-416f-834e-e344fc5c16a4)

Проверяем файл на локальном диске ноды
```
sudo cat /mnt/k8s-storage/data/data.log | tail -10
```

![0002-5](https://github.com/user-attachments/assets/52a11914-bc5c-48bc-9b79-abc5a4cfe392)

Удаляем Deployment
``` 
kubectl delete deployment data-exchange-pv
```
Также проверяем, что поды удалились
```
kubectl get pods -l app=data-exchange-pv
```

![0002-8](https://github.com/user-attachments/assets/014fb377-d360-4c53-b952-a58857a83e16)

Удаляем PVC
```
kubectl delete pvc local-pvc
```
Наблюдаем за состоянием PV
```
kubectl get pv local-pv
```

![0002-10](https://github.com/user-attachments/assets/74381921-b1d3-43b7-bfb0-36b040fb3f4b)

```
kubectl describe pv local-pv
```

![0002-11](https://github.com/user-attachments/assets/5a7b7024-7927-40a4-847f-c58797fcb9c8)

Проверяем, что файл сохранился на локальном диске после удаления PVC

![0002-13](https://github.com/user-attachments/assets/f9c324bf-c53b-47a2-8e84-35409385f02f)

Удаляем PV
```
kubectl delete pv local-pv
```
Проверяем что произошло с PV
```
kubectl get pv local-pv
```

![0002-15](https://github.com/user-attachments/assets/ccdeb257-1db2-4960-bc72-e46d56640289)

Проверяем, что произошло с файлом после удаления PV
```
sudo ls -la /mnt/k8s-storage/data/
sudo cat /mnt/k8s-storage/data/data.log | tail -5
```

![0002-16](https://github.com/user-attachments/assets/6b211aea-080f-4de2-9360-6b4a552ee22b)

Почему PV перешел в статус Released?
```
Status: Released
Reclaim Policy: Retain
```
- Reclaim Policy: Retain означает, что при удалении PVC данные сохраняются;
- PV переходит в статус Released, ожидая ручного вмешательства;
- Данные на диске не удаляются автоматически.

Почему файл сохранился после удаления PV?
- Локальный PV использует реальную директорию на ноде `/mnt/k8s-storage/data/`;
- Удаление PV удаляет только объект Kubernetes, но не файлы на диске;
- Данные сохраняются независимо от существования PV/PVC в кластере.

---

## 3. StorageClass
Задача
Создать Deployment приложения, использующего PVC, созданный на основе StorageClass.

Шаги выполнения
Создать Deployment приложения, состоящего из контейнеров busybox и multitool, использующего созданный ранее PVC.
Создать SC и PVC для подключения папки на локальной ноде, которая будет использована в поде.
Продемонстрировать, что контейнер multitool может читать данные из файла в смонтированной директории, в который busybox записывает данные каждые 5 секунд.

Что сдать на проверку
- Манифесты:
sc.yaml
- Скриншоты:
каждый шаг выполнения задания, начиная с шага 2

Шаблоны манифестов с учебными комментариями

1. Deployment (containers-data-exchange.yaml)
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: data-exchange
spec:
  replicas: # ЗАДАНИЕ: Укажите количество реплик
  selector:
    matchLabels:
      app: # ДОПОЛНИТЕ: Метка для селектора
  template:
    metadata:
      labels:
        app: # ПОВТОРИТЕ: Метка из selector.matchLabels
    spec:
      containers:
      - name: # ДОПОЛНИТЕ: Имя первого контейнера
        image: busybox
        command: ["/bin/sh", "-c"] 
        args: ["echo $(date) > путь_к_файлу; sleep 3600"] # КЛЮЧЕВОЕ: Команда записи данных в файл в директории из секции volumeMounts контейнера
        volumeMounts:
        - name: # ДОПОЛНИТЕ: Имя монтируемого раздела. Должно совпадать с именем эфемерного хранилища, объявленного на уровне пода.
          mountPath: # КЛЮЧЕВОЕ: Путь монтирования эфемерного хранилища внутри контейнера 1
      - name: # ДОПОЛНИТЕ: Имя второго контейнера
        image: busybox
        command: ["/bin/sh", "-c"]
        args: ["tail -f путь_к_файлу"] # КЛЮЧЕВОЕ: Команда для чтения данных из файла, расположенного в директории, указанной в volumeMounts контейнера
        volumeMounts:
        - name: # ДОПОЛНИТЕ: Имя монтируемого раздела. Должно совпадать с именем эфемерного хранилища, объявленного на уровне пода
          mountPath: # КЛЮЧЕВОЕ: Путь монтирования эфемерного хранилища внутри контейнера 2
      volumes:
      - name: # ДОПОЛНИТЕ: Имя монтируемого раздела эфемерного хранилища
        emptyDir: {} # ИНФОРМАЦИЯ: Определяем эфемерное хранилище, которое работает только внутри пода
```

2. Deployment (pv-pvc.yaml)
```
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: # ДОПОЛНИТЕ: Имя хранилища
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: # КЛЮЧЕВОЕ: Путь к директории на ноде (хосте, на котором развёрнут кластер)
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: # ДОПОЛНИТЕ: Имя PVC
spec:
  volumeName: # ДОПОЛНИТЕ: Имя PV, к которому будет привязан PVC, должен совпадать с созданным ранее PV
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: # ДОПОЛНИТЕ: Какой объём хранилища вы хотите передать в контейнер. Должно быть меньше или равно параметру storage из PV
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: data-exchange-pvc
spec:
  replicas: # ЗАДАНИЕ: Укажите количество реплик
  selector:
    matchLabels:
      app: # ДОПОЛНИТЕ: Метка для селектора
  template:
    metadata:
      labels:
        app: # ПОВТОРИТЕ: Метка из selector.matchLabels
    spec:
      containers:
      - name: # ДОПОЛНИТЕ: Имя первого контейнера
        image: busybox
        command: ["/bin/sh", "-c"] 
        args: ["echo $(date) > путь_к_файлу; sleep 3600"] # КЛЮЧЕВОЕ: Команда записи данных в файл в директории из секции volumeMounts контейнера 
        volumeMounts:
        - name: # ДОПОЛНИТЕ: Имя монтируемого раздела. Должно совпадать с именем хранилища, объявленного на уровне пода
          mountPath: # КЛЮЧЕВОЕ: Путь монтирования хранилища внутри контейнера 1
      - name: # ДОПОЛНИТЕ: Имя второго контейнера
        image: busybox
        command: ["/bin/sh", "-c"]
        args: ["tail -f путь_к_файлу"] # КЛЮЧЕВОЕ: Команда для чтения данных из файла, расположенного в директории, указанной в volumeMounts контейнера
        volumeMounts:
        - name: # ДОПОЛНИТЕ: Имя монтируемого раздела. Должно совпадать с именем хранилища, объявленного на уровне пода
          mountPath: # КЛЮЧЕВОЕ: Путь монтирования хранилища внутри контейнера 2
      volumes:
      - name: # ДОПОЛНИТЕ: Имя монтируемого раздела хранилища
        persistentVolumeClaim:
          claimName: # КЛЮЧЕВОЕ: Совпадает с именем PVC объявленного ранее
```

3. Deployment (sc.yaml)
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: # ДОПОЛНИТЕ: Имя StorageClass
provisioner: kubernetes.io/no-provisioner # ИНФОРМАЦИЯ: Нет автоматического развёртывания
volumeBindingMode: WaitForFirstConsumer
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: # ДОПОЛНИТЕ: Имя PVC
spec:
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: # ДОПОЛНИТЕ: Какой объем хранилища вы хотите передать в контейнер. Должно быть меньше или равно параметру storage из PV
  storageClassName: # ДОПОЛНИТЕ: Имя StorageClass. Должно совпадать с объявленным ранее
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: data-exchange-sc
spec:
  replicas: # ЗАДАНИЕ: Укажите количество реплик
  selector:
    matchLabels:
      app: # ДОПОЛНИТЕ: Метка для селектора
  template:
    metadata:
      labels:
        app: # ПОВТОРИТЕ: Метка из selector.matchLabels
    spec:
      containers:
      - name: # ДОПОЛНИТЕ: Имя первого контейнера
        image: busybox
        command: ["/bin/sh", "-c"] 
        args: ["echo $(date) > путь_к_файлу; sleep 3600"] # КЛЮЧЕВОЕ: Команда для чтения данных из файла, расположенного в директории, указанной в volumeMounts контейнера
        volumeMounts:
        - name: # ДОПОЛНИТЕ: Имя монтируемого раздела. Должно совпадать с именем хранилища, объявленного на уровне пода
          mountPath: # КЛЮЧЕВОЕ: Путь монтирования хранилища внутри контейнера 1
      - name: # ДОПОЛНИТЕ: Имя второго контейнера
        image: busybox
        command: ["/bin/sh", "-c"]
        args: ["tail -f путь_к_файлу"] # КЛЮЧЕВОЕ: Команда для чтения данных из файла, расположенного в директории, указанной в volumeMounts контейнера
        volumeMounts:
        - name: # ДОПОЛНИТЕ: Имя монтируемого раздела. Должно совпадать с именем хранилища, объявленного на уровне пода
          mountPath: # КЛЮЧЕВОЕ: Путь монтирования хранилища внутри контейнера 2
      volumes:
      - name: # ДОПОЛНИТЕ: Имя монтируемого раздела хранилища
        persistentVolumeClaim:
          claimName: # КЛЮЧЕВОЕ: Совпадает с именем PVC объявленного ранее
```

## Ответ 3

[Cсылка на манифест](https://github.com/IlyaBridge/homework/tree/main/Kubernetes-5/task-3/manifests)

Запускаем манифест sc.yaml
```
kubectl apply -f sc.yaml
```

![0003-0001-1(Запускаем)](https://github.com/user-attachments/assets/8ee553d0-ed0c-4c22-a5c5-e4e81743083e)

Проверяем создание ресурсов
```
kubectl get storageclass
kubectl get pv,pvc
kubectl get deployments
kubectl get pods
```

![0003-0001-2(Проверяем создание )](https://github.com/user-attachments/assets/fbede1cf-7953-4b15-acf1-d390cac839ad)

StorageClass
```
kubectl get storageclass -o wide
kubectl describe storageclass local-storage
```

![0003-0001-3  (ответ)](https://github.com/user-attachments/assets/4f2cf4f8-67da-4be5-8601-56701e94f1a0)

PV и PVC
```
kubectl get pv,pvc -o wide
kubectl describe pv local-pv-sc 
```

![0003-002 (Скриншот PV и PVC)](https://github.com/user-attachments/assets/bce2545a-bd8b-4c0b-a9b5-ca474d0a43f2)

Deployment
```
kubectl get deployments -o wide
```

![0003-003 (Скриншот Deployment)](https://github.com/user-attachments/assets/4b49a9ba-b3f8-485d-811f-efea542a1ba0)

```
kubectl describe deployment data-exchange-sc
```

![0003-004 (Скриншот Deployment)](https://github.com/user-attachments/assets/22fd90ab-81f7-4599-b92a-6246a880ec49)

Pods
```
kubectl get pods -o wide
```

![0003-005 (Скриншот Pods)](https://github.com/user-attachments/assets/c4028e07-ab53-4bc6-b90a-eca15b60f2c3)

```
kubectl describe pod $POD_NAME
```

![0003-006 (Скриншот Pods)](https://github.com/user-attachments/assets/bab41be2-dc2a-4256-8bae-8c5fbf85e41b)

Работа приложения
```
kubectl logs $POD_NAME -c multitool --tail=20
```

![0003-007 (Скриншот работы приложения)](https://github.com/user-attachments/assets/dbc3a595-ea90-4393-9868-e9c2c00ba7cc)

Локальный файл
```
sudo cat /mnt/k8s-storage/sc-data/data.log | tail -15
sudo ls -la /mnt/k8s-storage/sc-data/
```

![0003-008 (Скриншот локального файла)](https://github.com/user-attachments/assets/a5e1cd3c-dfd2-4a8e-9f31-52b0209d5558)

![0003-009 (Скриншот локального файла)](https://github.com/user-attachments/assets/7cc5c12d-5cbc-4ae8-821c-51be54eb9987)

---
