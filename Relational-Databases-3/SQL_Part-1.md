# Домашнее задание к занятию "`SQL. Часть 1`" - `Казначеев Илья`

---

### Задание 1
Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.

### Решение 1
```
SELECT DISTINCT district
FROM address
WHERE district LIKE 'K%a' AND district NOT LIKE '% %';
```

![ДЗ Задание 1](https://github.com/user-attachments/assets/6dca7be0-18cb-4288-aeb0-9a3d24e769f0)

---

### Задание 2
Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года включительно и стоимость которых превышает 10.00.

### Решение 2
```
SELECT *
FROM payment
WHERE payment_date BETWEEN '2005-06-15' AND '2005-06-18'
  AND amount > 10.00;
```

![ДЗ Задание 2](https://github.com/user-attachments/assets/30d7242f-8db3-44e1-a206-2dfd8893c337)

---

### Задание 3
Получите последние пять аренд фильмов.

### Решение 3
```
SELECT *
FROM rental
ORDER BY rental_date DESC
LIMIT 5;
```

![ДЗ Задание 3](https://github.com/user-attachments/assets/e3d9097c-1a23-4dec-af92-5cb39e6131bb)

---

### Задание 4
Одним запросом получите активных покупателей, имена которых Kelly или Willie.
Сформируйте вывод в результат таким образом:
все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
замените буквы 'll' в именах на 'pp'.

### Решение 4
```
SELECT 
    LOWER(first_name) AS first_name, 
    LOWER(last_name) AS last_name,
    REPLACE(LOWER(first_name), 'll', 'pp') AS modified_first_name
FROM customer
WHERE active = 1 AND (first_name = 'Kelly' OR first_name = 'Willie');
```

![ДЗ Задание 4](https://github.com/user-attachments/assets/827dc005-88ca-458c-8f81-16b006fb4392)

---

### Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 5*
Выведите Email каждого покупателя, разделив значение Email на две отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй — значение, указанное после @.

### Решение 5*
```
SELECT 
    SUBSTRING_INDEX(email, '@', 1) AS email_prefix,
    SUBSTRING_INDEX(email, '@', -1) AS email_domain
FROM customer;
```

![ДЗ Задание 5](https://github.com/user-attachments/assets/321430b6-4e21-450f-b0c9-7c5fa06dd127)

---

### Задание 6*
Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные — строчными.

### Решение 6*
```
SELECT 
    CONCAT(
        UPPER(LEFT(SUBSTRING_INDEX(email, '@', 1), 1)), 
        LOWER(SUBSTRING(SUBSTRING_INDEX(email, '@', 1), 2))
    ) AS email_prefix,
    CONCAT(
        UPPER(LEFT(SUBSTRING_INDEX(email, '@', -1), 1)), 
        LOWER(SUBSTRING(SUBSTRING_INDEX(email, '@', -1), 2))
    ) AS email_domain
FROM customer;
```

![ДЗ Задание 6](https://github.com/user-attachments/assets/05e1f1af-6747-45c5-b610-d809d42812fd)

---


---
