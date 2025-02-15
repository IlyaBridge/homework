# Домашнее задание к занятию "`SQL. Часть 2`" - `Казначеев Илья`

---

### Задание 1
Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию:

фамилия и имя сотрудника из этого магазина;
город нахождения магазина;
количество пользователей, закреплённых в этом магазине.


### Решение 1
```
SELECT 
    s.first_name AS staff_first_name,
    s.last_name AS staff_last_name,
    c.city AS store_city,
    COUNT(cu.customer_id) AS customer_count
FROM 
    store st
JOIN 
    staff s ON st.manager_staff_id = s.staff_id
JOIN 
    address a ON st.address_id = a.address_id
JOIN 
    city c ON a.city_id = c.city_id
JOIN 
    customer cu ON st.store_id = cu.store_id
GROUP BY 
    st.store_id
HAVING 
    COUNT(cu.customer_id) > 300;
```

![Задание 1 (Ч-2)](https://github.com/user-attachments/assets/e618ea40-98fe-44a0-bf75-abb0d4174102)

---

### Задание 2
Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

### Решение 2
```
SELECT 
    COUNT(*) AS films_count
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film);
```

![Задание 2 (Ч-2)](https://github.com/user-attachments/assets/b1063210-1041-434d-ac48-dfa3a1edeca1)

---

### Задание 3
Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

### Решение 3
```
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    SUM(amount) AS total_amount,
    COUNT(DISTINCT rental_id) AS rental_count
FROM 
    payment
GROUP BY 
    payment_month
ORDER BY 
    total_amount DESC
LIMIT 1;
```

![Задание 3 (Ч-2)](https://github.com/user-attachments/assets/97625d78-b708-4bb8-ae96-b7dd7d0183a9)

---

### Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 4*
Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».

### Решение 4*
```
SELECT 
    staff_id,
    COUNT(payment_id) AS sales_count,
    CASE 
        WHEN COUNT(payment_id) > 8000 THEN 'Да'
        ELSE 'Нет'
    END AS Премия
FROM 
    payment
GROUP BY 
    staff_id;
```

![Задание 4 (Ч-2)](https://github.com/user-attachments/assets/6bf02b56-40bb-466a-ac97-089a44c5b844)

---

### Задание 5*
Найдите фильмы, которые ни разу не брали в аренду.

### Решение 5*
```
SELECT 
    f.film_id,
    f.title
FROM 
    film f
LEFT JOIN 
    inventory i ON f.film_id = i.film_id
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    r.rental_id IS NULL;
```

![Задание 5 (Ч-2)](https://github.com/user-attachments/assets/60aacc30-6af3-4104-89fc-7dd0634a89ab)

---
