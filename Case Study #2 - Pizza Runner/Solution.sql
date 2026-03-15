-- 1) How many pizzas were ordered?
SELECT COUNT(pizza_id) AS Total_pizza_ordered
FROM customer_orders_clean;


-- 2) How many unique customer orders were made?
SELECT COUNT(DISTINCT customer_id) AS unique_customer_orders
FROM customer_orders_clean;


-- 3) How many successful orders were delivered by each runner?
SELECT
  runner_id,
  COUNT(*) AS successful_orders_count
FROM runner_orders_clean
WHERE cancellation IS NULL
GROUP BY runner_id;


-- 4) How many of each type of pizza was delivered?
SELECT 
  c.pizza_id,
  COUNT(c.pizza_id) AS pizza_delivered_count
FROM customer_orders_clean c
INNER JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.pizza_id;


-- 5) How many Vegetarian and Meatlovers were ordered by each customer?
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


-- 6) What was the maximum number of pizzas delivered in a single order?
SELECT
  c.order_id,
  COUNT(c.order_id) AS pizza_delivered_count
FROM customer_orders_clean c
INNER JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.order_id
ORDER BY pizza_delivered_count DESC
LIMIT 1;


-- 7) For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT
  c.customer_id,
  SUM(CASE
    WHEN c.extras IS NOT NULL OR c.exclusions IS NOT NULL 
    THEN 1
    ELSE 0
  END) AS changed_count,
  SUM(CASE
    WHEN c.extras IS NULL AND c.exclusions IS NULL
    THEN 1
    ELSE 0
  END) AS unchanged_count
FROM customer_orders_clean c
INNER JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.customer_id
ORDER BY c.customer_id;


-- 8) How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(c.pizza_id) AS pizza_delivered_count
FROM customer_orders_clean c
INNER JOIN runner_orders_clean r ON c.order_id = r.order_id
WHERE
  cancellation IS NULL 
  AND c.exclusions IS NOT NULL 
  AND c.extras IS NOT NULL;


-- 9) What was the total volume of pizzas ordered for each hour of the day?
SELECT
  EXTRACT(HOUR FROM order_time) AS hours_of_day,
  COUNT(order_id) AS pizzas_orderd
FROM customer_orders_clean
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY hours_of_day ASC;


-- 10) What was the volume of orders for each day of the week?
SELECT
  DAYNAME(order_time) AS day_of_week,
  COUNT(order_id) AS pizzas_ordered
FROM customer_orders_clean
GROUP BY
  DAYNAME(order_time),
  WEEKDAY(order_time)
ORDER BY WEEKDAY(order_time);
