#!/bin/bash

PORT=80
INDEX_FILE="/var/www/html/index.html"

# Проверка доступности порта
if ! nc -z localhost $PORT; then
    echo "Port $PORT is not available"
    exit 1
fi

# Проверка наличия файла index.html
if [ ! -f "$INDEX_FILE" ]; then
    echo "File $INDEX_FILE does not exist"
    exit 1
fi

exit 0
