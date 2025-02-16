-- Задание 1
SELECT 
    (SUM(index_length) / NULLIF(SUM(data_length + index_length), 0)) * 100 AS index_to_table_ratio
FROM 
    information_schema.TABLES
WHERE 
    table_schema = 'sakila';

-- Задание 2
-- Оптимизированный запрос
SELECT 
    CONCAT(c.last_name, ' ', c.first_name) AS customer_name,
    SUM(p.amount) OVER (PARTITION BY c.customer_id, f.title) AS total_amount
FROM 
    payment p
JOIN 
    rental r 
    ON p.rental_id = r.rental_id
JOIN 
    customer c 
    ON r.customer_id = c.customer_id
JOIN 
    inventory i 
    ON r.inventory_id = i.inventory_id
JOIN 
    film f 
    ON i.film_id = f.film_id
WHERE 
    p.payment_date >= '2005-07-30' 
    AND p.payment_date < '2005-07-31';
    
-- Индексы
-- Для ускорения запроса добавили индексы на ключевые колонки:
CREATE INDEX idx_payment_date ON payment(payment_date);
CREATE INDEX idx_rental_id ON rental(rental_id);
CREATE INDEX idx_customer_id ON customer(customer_id);
CREATE INDEX idx_inventory_id ON inventory(inventory_id);
CREATE INDEX idx_film_id ON film(film_id);

-- Результат EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT 
    CONCAT(c.last_name, ' ', c.first_name) AS customer_name,
    SUM(p.amount) OVER (PARTITION BY c.customer_id, f.title) AS total_amount
FROM 
    payment p
JOIN 
    rental r 
    ON p.rental_id = r.rental_id
JOIN 
    customer c 
    ON r.customer_id = c.customer_id
JOIN 
    inventory i 
    ON r.inventory_id = i.inventory_id
JOIN 
    film f 
    ON i.film_id = f.film_id
WHERE 
    p.payment_date >= '2005-07-30' 
    AND p.payment_date < '2005-07-31';
