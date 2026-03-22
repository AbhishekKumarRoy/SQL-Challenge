-- 1) How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
  EXTRACT(WEEK FROM registration_date + 3) AS weeks,
  # Added 3 because 2021-01-01 is Friday and it will come under 53 week for 2020 and not 1 for 2021
  COUNT(DISTINCT runner_id) AS runner_signedup_count
FROM runners
GROUP BY EXTRACT(WEEK FROM registration_date + 3);


-- 2) What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT 
  ROUND(
    AVG(
      DISTINCT EXTRACT(
        MINUTE FROM (o.order_time - r.pickup_time)
      )
    ), 2
  ) AS avg_time
FROM runner_orders_clean r
LEFT JOIN customer_orders_clean o ON r.order_id = o.order_id;


-- 3) Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH orders_group AS (
  SELECT 
    r.order_id,
    COUNT(r.order_id) AS pizza_count,
    TIMESTAMPDIFF(
      MINUTE, MAX(c.order_time), MAX(r.pickup_time)
    ) AS time_to_prepare
  FROM runner_orders_clean r
  LEFT JOIN customer_orders_clean c ON r.order_id = c.order_id
  GROUP BY r.order_id
)
SELECT
  pizza_count,
  ROUND(
    AVG(time_to_prepare)
  ) AS time_to_prepare_in_minutes
FROM orders_group
GROUP BY pizza_count
ORDER BY pizza_count DESC;


-- 4) What was the average distance travelled for each customer?
WITH distance_grouped AS (
  SELECT
    c.customer_id,
    c.order_id,
    r.distance
  FROM customer_orders_clean c
  INNER JOIN runner_orders_clean r ON c.order_id = r.order_id
  # Removing duplicates by using group by
  GROUP BY
    c.customer_id,
    c.order_id
  ORDER BY c.customer_id ASC
)
SELECT
  customer_id,
  ROUND(AVG(distance), 2) AS avg_distance
FROM distance_grouped
GROUP BY customer_id
ORDER BY customer_id;


-- 5) What was the difference between the longest and shortest delivery times for all orders?
SELECT
  MAX(duration) - MIN(duration) AS delivery_time_difference
FROM runner_orders_clean;


-- 6) What was the average speed for each runner for each delivery and do you notice any trend for these values?
WITH runner_grouped AS (
  SELECT
    r.runner_id,
    ro.order_id,
    MAX(duration) AS duration,
    MAX(distance) AS distance,
    COUNT(ro.runner_id) AS delivery_count
  FROM runners r
  LEFT JOIN runner_orders_clean ro ON r.runner_id = ro.runner_id
  WHERE ro.cancellation IS NULL
  GROUP BY
    r.runner_id,
    ro.order_id
)
SELECT
  runner_id,
  order_id,
  ROUND(distance/(duration/60), 2) AS avg_speed
FROM runner_grouped
ORDER BY
  runner_id,
  avg_speed DESC;


-- 7) What is the successful delivery percentage for each runner?
SELECT
  runner_id,
  ROUND(
    SUM(
      CASE
        WHEN cancellation IS NULL
        THEN 1
        ELSE 0
      END
    ) * 100 / COUNT(*)
  ) AS delivery_percentage
FROM runner_orders_clean ru
GROUP BY runner_id
ORDER BY delivery_percentage;
