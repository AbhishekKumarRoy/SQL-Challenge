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
