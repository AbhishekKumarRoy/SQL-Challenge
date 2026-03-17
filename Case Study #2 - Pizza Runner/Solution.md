# A. Pizza Metrics

### 1. How many pizzas were ordered?
```sql
USE pizza;

SELECT COUNT(pizza_id) AS total_pizza_ordered
FROM customer_orders_clean;
```
#### Output
| total_pizza_ordered |
|-------------|
| 14          | 


### 2. How many unique customer orders were made?
```sql
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM customer_orders_clean;
```
#### Output
| unique_customer_orders |
|-------------|
| 10          | 


### 3. How many successful orders were delivered by each runner?
```sql
SELECT 
	runner_id,
    COUNT(*) AS successful_orders_count
FROM runner_orders_clean
WHERE cancellation IS NULL
GROUP BY runner_id;
```
#### Output
| runner_id | successful_orders_count |
|-------------|-------------|
| 1          | 4            |
| 2          | 3            |
| 3          | 1            |


### 4. How many of each type of pizza was delivered?
```sql
SELECT 
	c.pizza_id,
    COUNT(c.pizza_id) AS pizza_delivered_count
FROM customer_orders_clean c
INNER JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.pizza_id;
```
#### Output
| pizza_id | pizza_delivered_count |
|-------------|-------------|
| 1          | 9            |
| 2          | 3            |


### 5. How many Vegetarian and Meatlovers were ordered by each customer?
```sql
SELECT 
	c.customer_id,
    p.pizza_name,
    COUNT(c.customer_id) AS pizza_count
FROM customer_orders_clean c
INNER JOIN pizza_names p ON c.pizza_id = p.pizza_id
GROUP BY 
	c.customer_id,
    p.pizza_name
ORDER BY c.customer_id ASC;
```
#### Output
| customer_id | pizza_name          | pizza_count|
|-------------|---------------------|------------|
|101          | Meatlovers          | 2          |
|101          | Vegetarian          | 1          |
|102          | Meatlovers          | 2          |
|102          | Vegetarian          | 1          |
|103          | Meatlovers          | 3          |
|103          | Vegetarian          | 1          |
|104          | Meatlovers          | 3          |
|105          | Vegetarian          | 1          |


### 6. What was the maximum number of pizzas delivered in a single order?
```sql
SELECT 
	c.order_id,
    COUNT(c.order_id) AS pizza_delivered_count
FROM customer_orders_clean c
INNER JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.order_id
ORDER BY pizza_delivered_count DESC
LIMIT 1;
```
#### Output
| order_id | pizza_delivered_count |
|-------------|-------------|
| 4          | 3            |


### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```sql
SELECT 
	c.customer_id,
    SUM(CASE
		WHEN c.extras IS NOT NULL OR c.exclusions IS NOT NULL THEN 1
        ELSE 0
	END) AS changed_count,
	SUM(CASE
		WHEN c.extras IS NULL AND c.exclusions IS NULL THEN 1
        ELSE 0
	END) AS unchanged_count
FROM customer_orders_clean c
INNER JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.customer_id
ORDER BY c.customer_id;
```
#### Output
| customer_id | changed_count | unchanged_count|
|-------------|------------|------------|
|101          | 0          | 2          |
|102          | 0          | 3          |
|103          | 3          | 0          |
|104          | 2          | 1          |
|105          | 1          | 0          |


### 8. How many pizzas were delivered that had both exclusions and extras?
```sql
SELECT COUNT(c.pizza_id) AS pizza_delivered_count
FROM customer_orders_clean c
INNER JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE cancellation IS NULL AND c.exclusions IS NOT NULL AND c.extras IS NOT NULL;
```
#### Output
| pizza_delivered_count |
|-------------|
| 1          | 


### 9. What was the total volume of pizzas ordered for each hour of the day?
```sql
SELECT 
	EXTRACT(HOUR FROM order_time) AS hours_of_day,
    COUNT(order_id) AS pizzas_orderd
FROM customer_orders_clean
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY hours_of_day ASC;
```
#### Output
| hours_of_day | pizzas_orderd |
|-------------|-------------|
| 11          | 1            |
| 13          | 3            |
| 18          | 3            |
| 19          | 1            |
| 21          | 3            |
| 23          | 3            |


### 10. What was the volume of orders for each day of the week?
```sql
SELECT 
	DAYNAME(order_time) AS day_of_week,
    COUNT(order_id) AS pizzas_ordered
FROM customer_orders_clean
GROUP BY 
	DAYNAME(order_time), 
	WEEKDAY(order_time)
ORDER BY WEEKDAY(order_time);
```
#### Output
| day_of_week | pizzas_ordered |
|-------------|--------------|
| Wednesday   | 5            |
| Thursday    | 3            |
| Friday      | 1            |
| Saturday    | 5            |


