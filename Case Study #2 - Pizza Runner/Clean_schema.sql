CREATE DATABASE pizza;
USE pizza;

CREATE TABLE runners (
  `runner_id` INTEGER,
  `registration_date` DATE
);
INSERT INTO runners
  (`runner_id`, `registration_date`)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

CREATE TABLE customer_orders (
  `order_id` INTEGER,
  `customer_id` INTEGER,
  `pizza_id` INTEGER,
  `exclusions` VARCHAR(4),
  `extras` VARCHAR(4),
  `order_time` TIMESTAMP
);

INSERT INTO customer_orders
  (`order_id`, `customer_id`, `pizza_id`, `exclusions`, `extras`, `order_time`)
VALUES
  (1, 101, 1, '', '', '2020-01-01 18:05:02'),
  (2, 101, 1, '', '', '2020-01-01 19:00:52'),
  (3, 102, 1, '', '', '2020-01-02 23:51:23'),
  (3, 102, 2, '', NULL, '2020-01-02 23:51:23'),
  (4, 103, 1, '4', '', '2020-01-04 13:23:46'),
  (4, 103, 1, '4', '', '2020-01-04 13:23:46'),
  (4, 103, 2, '4', '', '2020-01-04 13:23:46'),
  (5, 104, 1, 'null', '1', '2020-01-08 21:00:29'),
  (6, 101, 2, 'null', 'null', '2020-01-08 21:03:13'),
  (7, 105, 2, 'null', '1', '2020-01-08 21:20:29'),
  (8, 102, 1, 'null', 'null', '2020-01-09 23:54:33'),
  (9, 103, 1, '4', '1, 5', '2020-01-10 11:22:59'),
  (10, 104, 1, 'null', 'null', '2020-01-11 18:34:49'),
  (10, 104, 1, '2, 6', '1, 4', '2020-01-11 18:34:49');

CREATE TABLE runner_orders (
  `order_id` INTEGER,
  `runner_id` INTEGER,
  `pickup_time` VARCHAR(19),
  `distance` VARCHAR(7),
  `duration` VARCHAR(10),
  `cancellation` VARCHAR(23)
);

INSERT INTO runner_orders
  (`order_id`, `runner_id`, `pickup_time`, `distance`, `duration`, `cancellation`)
VALUES
  (1, 1, '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  (2, 1, '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  (3, 1, '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  (4, 2, '2020-01-04 13:53:03', '23.4', '40', NULL),
  (5, 3, '2020-01-08 21:10:57', '10', '15', NULL),
  (6, 3, 'null', 'null', 'null', 'Restaurant Cancellation'),
  (7, 2, '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  (8, 2, '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  (9, 2, 'null', 'null', 'null', 'Customer Cancellation'),
  (10, 1, '2020-01-11 18:50:20', '10km', '10minutes', 'null');

CREATE TABLE pizza_names (
  `pizza_id` INTEGER,
  `pizza_name` TEXT
);
INSERT INTO pizza_names
  (`pizza_id`, `pizza_name`)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

CREATE TABLE pizza_recipes (
  `pizza_id` INTEGER,
  `toppings` TEXT
);
INSERT INTO pizza_recipes
  (`pizza_id`, `toppings`)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

CREATE TABLE pizza_toppings (
  `topping_id` INTEGER,
  `topping_name` TEXT
);
INSERT INTO pizza_toppings
  (`topping_id`, `topping_name`)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
#-------------------------------------------------- Cleaning Data ----------------------------------------------- 
USE pizza;

# customer_orders_clean
CREATE TABLE customer_orders_clean AS
SELECT 
  order_id,
  customer_id,
  pizza_id,
  NULLIF(NULLIF(exclusions, 'null'), '') AS exclusions,
  NULLIF(NULLIF(extras, 'null'), '') AS extras,
  order_time

FROM customer_orders;

# runner_orders_clean
CREATE TABLE runner_orders_clean AS
SELECT 
    order_id,
    runner_id,
    NULLIF(pickup_time, 'null') AS pickup_time,

    CAST(
        NULLIF(REPLACE(REPLACE(distance,'km',''),' ',''),'null')
        AS DECIMAL(5,2)
    ) AS distance,

    CAST(
        NULLIF(
            REPLACE(
                REPLACE(
                    REPLACE(duration,'minutes',''),
                'mins',''),
            'minute',''),
        'null')
        AS UNSIGNED
    ) AS duration,

    NULLIF(NULLIF(cancellation, 'null'), '') AS cancellation
    
FROM runner_orders;


# pizza_recipes_clean
CREATE TABLE pizza_recipes_clean (
    pizza_id INT,
    topping_id INT
);

INSERT INTO pizza_recipes_clean (pizza_id, topping_id)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n <= 10
)
SELECT 
    pr.pizza_id,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(pr.toppings, ',', numbers.n), ',', -1)) AS topping_id
FROM pizza_recipes pr
JOIN numbers
ON CHAR_LENGTH(pr.toppings) - CHAR_LENGTH(REPLACE(pr.toppings, ',', '')) >= numbers.n - 1;


-- Adding primary Key's
ALTER TABLE runners
ADD PRIMARY KEY (runner_id);

ALTER TABLE pizza_names
ADD PRIMARY KEY (pizza_id);

ALTER TABLE pizza_toppings
ADD PRIMARY KEY (topping_id);

ALTER TABLE runner_orders_clean
ADD PRIMARY KEY (order_id);

ALTER TABLE pizza_recipes_clean
ADD PRIMARY KEY (pizza_id, topping_id);

ALTER TABLE customer_orders_clean
ADD PRIMARY KEY (order_id, pizza_id);


# Adding Foreign Keys
ALTER TABLE customer_orders_clean
ADD CONSTRAINT fk_pizza
FOREIGN KEY (pizza_id)
REFERENCES pizza_names(pizza_id);


ALTER TABLE runner_orders_clean
ADD CONSTRAINT fk_runner
FOREIGN KEY (runner_id)
REFERENCES runners(runner_id);


ALTER TABLE runner_orders_clean
ADD CONSTRAINT fk_order
FOREIGN KEY (order_id)
REFERENCES customer_orders_clean(order_id);


ALTER TABLE pizza_recipes_clean
ADD CONSTRAINT fk_recipe_pizza
FOREIGN KEY (pizza_id)
REFERENCES pizza_names(pizza_id);


ALTER TABLE pizza_recipes_clean
ADD CONSTRAINT fk_recipe_topping
FOREIGN KEY (topping_id)
REFERENCES pizza_toppings(topping_id);


# MySQL internally converts all UNSIGNED casts to BIGINT UNSIGNED in during create table as select. 
# So, changing the duration to INTEGER using ALTAR.
ALTER TABLE runner_orders_clean
MODIFY duration INTEGER;

# Changing the data type from TEXT to VARCHAR. TEXT is used to store large data like articles, post and is slower compared to VARCHAR
ALTER TABLE pizza_names
MODIFY pizza_name VARCHAR(50);

ALTER TABLE pizza_toppings
MODIFY topping_name VARCHAR(50);
