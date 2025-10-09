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

Скрин + 
0001-4 (Проверяем линтинг чарта)

Тестируем рендеринг шаблонов

Скрин +
0001-5 (Тестируем рендеринг шаблонов)

Пакетируем чарт

Скрин +
0001-6 (Пакетируем чарт)

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

Скрин +

0002-1 (Создаем неймспейсы)
0002-2 (Проверяем создание)

### УСТАНОВКА ПЕРВОЙ ВЕРСИИ (app1-v1)
Устанавливаем первую версию

Скрин +
0002-3 (Устанавливаем первую версию)
0002-4 (Устанавливаем первую версию)

### УСТАНОВКА ВТОРОЙ ВЕРСИИ (app1-v2)
Устанавливаем вторую версию в том же неймспейсе
Скрин +
0002-6 (Устанавливаем вторую версию в том же неймспейсе)
0002-7 (Проверяем установку)

### УСТАНОВКА ТРЕТЬЕЙ ВЕРСИИ (app2)
Устанавливаем третью версию в другом неймспейсе
Скрин +
0002-8 (Устанавливаем третью версию в другом неймспейсе)
0002-9 (Проверяем установку)

### РЕЗУЛЬТАТ
Все релизы во всех неймспейсах

Скрин +
0002-10 (Обзор всех релизов)

Все поды с версиями образов

Скрин +
0002-11 (Все поды с версиями образов)

Информация по app1
Скрин +
0002-12 (Детали по app1)

Информация по app2
Скрин +
0002-13 (Детали по app2)

Проверяем переменные для подтверждения версий
Скрин +
0002-14 (Проверка переменных окружения)

### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

---
