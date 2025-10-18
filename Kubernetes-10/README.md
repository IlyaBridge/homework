#  «Домашнее задание к занятию» "`Как работает сеть в K8S`" - `Казначеев Илья`

https://github.com/netology-code/kuber-homeworks/blob/shkuber-16/3.3/3.3.md

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

### Ответ

Запуск Minikube

![00001-2 -ОТВЕТ](https://github.com/user-attachments/assets/72cd9947-892e-4894-b3e0-24857e8fd8dc)

Namespace

![00001-3 -ОТВЕТ](https://github.com/user-attachments/assets/85575ebe-a8b2-4269-8855-783ea7b85482)

Тестируем доступ без сетевых политик:

![00001-6 -ОТВЕТ](https://github.com/user-attachments/assets/1f007d8e-74b4-4e6a-87d0-f2ec878d6348)

Применяем сетевые политики:

![00001-7 -ОТВЕТ](https://github.com/user-attachments/assets/86257414-7da3-441d-ad0b-099b990d343c)

Тестируем доступ после применения политик:

![00001-9 -ОТВЕТ исправление](https://github.com/user-attachments/assets/08c4fc10-4b9f-4f16-880d-854d9203ae69)

Детали сетевых политик
```
kubectl describe networkpolicies -n app
```

![00001-10-1 -ОТВЕТ исправление](https://github.com/user-attachments/assets/10b5ccbe-3d5f-4d24-af84-96d7a6560092)

Файлы проекта:

[00-namespace.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-10/k8s-network-policy-app/k8s-network-policy-app/00-namespace.yaml)
[01-deployments-services.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-10/k8s-network-policy-app/k8s-network-policy-app/01-deployments-services.yaml)
[02-network-policies.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-10/k8s-network-policy-app/k8s-network-policy-app/02-network-policies.yaml)
[03-test-pod.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-10/k8s-network-policy-app/k8s-network-policy-app/03-test-pod.yaml)

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

