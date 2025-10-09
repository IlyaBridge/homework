#  «Домашнее задание к занятию» "`«Helm»`" - `Казначеев Илья`

https://github.com/netology-code/kuber-homeworks/blob/shkuber-16/2.4/2.4.md

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

### Ответ 1

Файл charts/myapp/Chart.yaml
```
apiVersion: v2
name: myapp
description: Multi-component application Helm chart
type: application
version: 0.1.0
appVersion: "1.0.0"
```

Файл charts/myapp/values.yaml
```
global:
  namespace: default
  environment: production

web:
  enabled: true
  name: "web-app"
  replicaCount: 2
  image:
    repository: "nginx"
    tag: "1.25"
    pullPolicy: "IfNotPresent"
  service:
    port: 80
    targetPort: 80
  env:
    APP_VERSION: "1.0"

api:
  enabled: true
  name: "api-app"
  replicaCount: 1
  image:
    repository: "nginx"
    tag: "1.25"
    pullPolicy: "IfNotPresent"
  service:
    port: 80
    targetPort: 80
  env:
    APP_VERSION: "1.0"
    API_ENV: "production"
```

Файл charts/myapp/templates/web/deployment.yaml
```
{{- if .Values.web.enabled }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.web.name }}
  namespace: {{ .Values.global.namespace }}
  labels:
    app: {{ .Values.web.name }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  replicas: {{ .Values.web.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Values.web.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.web.name }}
        version: "{{ .Values.web.image.tag }}"
    spec:
      containers:
        - name: web
          image: "{{ .Values.web.image.repository }}:{{ .Values.web.image.tag }}"
          imagePullPolicy: {{ .Values.web.image.pullPolicy }}
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          env:
            - name: APP_VERSION
              value: {{ .Values.web.env.APP_VERSION | quote }}
            - name: NAMESPACE
              value: {{ .Values.global.namespace | quote }}
            - name: ENVIRONMENT
              value: {{ .Values.global.environment | quote }}
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 5
{{- end }}

```

Файл charts/myapp/templates/web/service.yaml
```
{{- if .Values.web.enabled }}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.web.name }}-service
  namespace: {{ .Values.global.namespace }}
  labels:
    app: {{ .Values.web.name }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  type: ClusterIP
  ports:
    - port: {{ .Values.web.service.port }}
      targetPort: {{ .Values.web.service.targetPort }}
      protocol: TCP
      name: http
  selector:
    app: {{ .Values.web.name }}
{{- end }}
```

Файл charts/myapp/templates/api/deployment.yaml
```
{{- if .Values.api.enabled }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.api.name }}
  namespace: {{ .Values.global.namespace }}
  labels:
    app: {{ .Values.api.name }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  replicas: {{ .Values.api.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Values.api.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.api.name }}
        version: "{{ .Values.api.image.tag }}"
    spec:
      containers:
        - name: api
          image: "{{ .Values.api.image.repository }}:{{ .Values.api.image.tag }}"
          imagePullPolicy: {{ .Values.api.image.pullPolicy }}
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          env:
            - name: APP_VERSION
              value: {{ .Values.api.env.APP_VERSION | quote }}
            - name: API_ENV
              value: {{ .Values.api.env.API_ENV | quote }}
            - name: NAMESPACE
              value: {{ .Values.global.namespace | quote }}
            - name: ENVIRONMENT
              value: {{ .Values.global.environment | quote }}
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 5
{{- end }}
```

Файл charts/myapp/templates/api/service.yaml
```
{{- if .Values.api.enabled }}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.api.name }}-service
  namespace: {{ .Values.global.namespace }}
  labels:
    app: {{ .Values.api.name }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  type: ClusterIP
  ports:
    - port: {{ .Values.api.service.port }}
      targetPort: {{ .Values.api.service.targetPort }}
      protocol: TCP
      name: http
  selector:
    app: {{ .Values.api.name }}
{{- end }}
```

Проверяем линтинг чарта

![0001-4 (Проверяем линтинг чарта)](https://github.com/user-attachments/assets/77d788f2-0e11-40eb-9f33-1af06aa00df3)

Тестируем рендеринг шаблонов

![0001-5 (Тестируем рендеринг шаблонов)](https://github.com/user-attachments/assets/1958c1e2-368c-41dd-857f-825f1a288632)

Пакетируем чарт

![0001-6 (Пакетируем чарт)](https://github.com/user-attachments/assets/8dedaeae-4f97-4449-8672-3c688a9219dc)

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

### Ответ 2

Файл values/app1-v1.yaml
```
global:
  namespace: app1
  environment: staging

web:
  enabled: true
  name: "web-app-v1"
  replicaCount: 2
  image:
    repository: "nginx"
    tag: "1.25"
  env:
    APP_VERSION: "1.0"

api:
  enabled: true
  name: "api-app-v1"
  replicaCount: 1
  image:
    repository: "nginx"
    tag: "1.25"
  env:
    APP_VERSION: "1.0"
    API_ENV: "staging"
```

Файл values-app1-v2.yaml
```
global:
  namespace: app1
  environment: staging

web:
  enabled: true
  name: "web-app-v2"
  replicaCount: 3
  image:
    repository: "nginx"
    tag: "1.26"
  env:
    APP_VERSION: "2.0"

api:
  enabled: true
  name: "api-app-v2"
  replicaCount: 2
  image:
    repository: "nginx"
    tag: "1.26"
  env:
    APP_VERSION: "2.0"
    API_ENV: "staging-v2"
```


Файл values/app2.yaml
```
global:
  namespace: app2
  environment: production

web:
  enabled: true
  name: "web-app"
  replicaCount: 1
  image:
    repository: "nginx"
    tag: "1.24"
  env:
    APP_VERSION: "1.0-stable"

api:
  enabled: true
  name: "api-app"
  replicaCount: 1
  image:
    repository: "nginx"
    tag: "1.24"
  env:
    APP_VERSION: "1.0-stable"
    API_ENV: "production"
```

Создаем неймспейсы

![0002-1 (Создаем неймспейсы)](https://github.com/user-attachments/assets/8369e2ca-3996-4d0a-8c35-bf65476fb983)

![0002-2 (Проверяем создание)](https://github.com/user-attachments/assets/cf4d38c5-ce0d-4509-9178-d1bcfb62775d)

### УСТАНОВКА ПЕРВОЙ ВЕРСИИ (app1-v1)
Устанавливаем первую версию

![0002-3 (Устанавливаем первую версию)](https://github.com/user-attachments/assets/1172d4ab-4020-4f9c-8066-205dcc02392d)

![0002-4 (Устанавливаем первую версию)](https://github.com/user-attachments/assets/e1dd4121-06aa-49fd-9479-6ef0e74a9090)

### УСТАНОВКА ВТОРОЙ ВЕРСИИ (app1-v2)
Устанавливаем вторую версию в том же неймспейсе

![0002-6 (Устанавливаем вторую версию в том же неймспейсе)](https://github.com/user-attachments/assets/c440fa30-6c26-4ff2-add1-4e8ca4d0bb8c)

![0002-7 (Проверяем установку)](https://github.com/user-attachments/assets/635feedf-936d-4e45-b77f-dd94305149a9)

### УСТАНОВКА ТРЕТЬЕЙ ВЕРСИИ (app2)
Устанавливаем третью версию в другом неймспейсе

![0002-8 (Устанавливаем третью версию в другом неймспейсе)](https://github.com/user-attachments/assets/dd9f5b5c-47ff-49c2-9a3d-3e03ffc5d5d6)

![0002-9 (Проверяем установку)](https://github.com/user-attachments/assets/49af8d08-22eb-43ff-b0aa-b9a03faa6d44)

### РЕЗУЛЬТАТ
Все релизы во всех неймспейсах

![0002-10 (Обзор всех релизов)](https://github.com/user-attachments/assets/d24ab35f-7187-43dc-92f6-21e5d641fe9a)

Все поды с версиями образов

![0002-11 (Все поды с версиями образов)](https://github.com/user-attachments/assets/a2b22248-21a6-477d-bc1d-0a3053c9ac5b)

Информация по app1

![0002-12 (Детали по app1)](https://github.com/user-attachments/assets/376048a6-b8d9-46dc-add9-ce6848056453)


Информация по app2

![0002-13 (Детали по app2)](https://github.com/user-attachments/assets/2e7a0662-34ce-454c-b38e-c838e465096f)

Проверяем переменные для подтверждения версий

![0002-14 (Проверка переменных окружения)](https://github.com/user-attachments/assets/db48780f-49fc-48df-be19-e2bca89edf17)

## Манифесты:
1. [Chart.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-7/task-1/myapp/Chart.yaml)
2. [values.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-7/task-1/myapp/values.yaml)
3. [web/deployment.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-7/task-1/myapp/templates/web/deployment.yaml) - Шаблон deployment для web компонента
4. [web/service.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-7/task-1/myapp/templates/web/service.yaml) - Шаблон service для web компонента
5. [api/deployment.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-7/task-1/myapp/templates/api/deployment.yaml) - Шаблон deployment для api компонента
6. [api/service.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-7/task-1/myapp/templates/api/service.yaml) - Шаблон service для api компонента
7. [app1-v1.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-7/task-2/values/app1-v1.yaml) - Конфигурация для версии 1 в app1
8. [app1-v2.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-7/task-2/values/app1-v2.yaml) - Конфигурация для версии 2 в app1
9. [app2.yaml](https://github.com/IlyaBridge/homework/blob/main/Kubernetes-7/task-2/values/app2.yaml) - Конфигурация для версии в app2

### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

---
