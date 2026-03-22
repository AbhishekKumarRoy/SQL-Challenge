# Case Study Questions


### 1. What is the total amount each customer spent at the restaurant?
```sql
SELECT
    s.customer_id,
    SUM(m.price) AS Total_sales
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;
```
#### Output
| customer_id | Total_sales |
|-------------|-------------|
| A           |          76 |
| B           |          74 |
| C           |          36 |


### 2. How many days has each customer visited the restaurant?
```sql
SELECT
    customer_id,
    COUNT(DISTINCT order_date) AS Time_visited
FROM sales
GROUP BY customer_id;
```
#### Output
| customer_id | Time_visited |
|-------------|--------------|
| A           |            4 |
| B           |            6 |
| C           |            2 |


### 3. What was the first item from the menu purchased by each customer?
```sql
SELECT
    DISTINCT s.customer_id,
    m.product_name
FROM sales s
JOIN menu m ON s.product_id = m.product_id
WHERE s.order_date IN (
    SELECT MIN(s.order_date) AS first_date
    FROM sales s
    GROUP BY s.customer_id
);
```
#### Output
| customer_id | product_name |
|-------------|--------------|
| A           | sushi        |
| A           | curry        |
| B           | curry        |
| C           | ramen        |


### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
```sql
SELECT
    m.product_name,
    COUNT(m.product_name) AS purchase_count
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;
```
#### Output
| product_name | purchase_count |
|--------------|----------------|
| ramen        |              8 |


### 5. Which item was the most popular for each customer?
```sql
WITH customer_purchases AS (
    SELECT
        s.customer_id,
        m.product_name,
        COUNT(*) AS product_count
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    GROUP BY
        s.customer_id,
        m.product_name
),
max_purchases AS (
    SELECT
        customer_id,
        MAX(product_count) AS max_count
    FROM customer_purchases
    GROUP BY customer_id
)
SELECT
    cp.customer_id,
    cp.product_name,
    cp.product_count
FROM customer_purchases cp
JOIN max_purchases mp ON cp.customer_id = mp.customer_id
    AND cp.product_count = mp.max_count;
```
#### Output
| customer_id | product_name | product_count |
|-------------|--------------|---------------|
| A           | ramen        |             3 |
| B           | curry        |             2 |
| B           | sushi        |             2 |
| B           | ramen        |             2 |
| C           | ramen        |             3 |


### 6. Which item was purchased first by the customer after they became a member?
```sql
SELECT
    s.customer_id,
    s.order_date AS first_order,
    me.product_name
FROM sales s
JOIN members m ON s.customer_id = m.customer_id
JOIN menu me ON s.product_id = me.product_id
WHERE 
    s.order_date >= m.join_date
    AND s.order_date = (
        SELECT MIN(s2.order_date)
        FROM sales s2
        WHERE s2.customer_id = s.customer_id
        AND s2.order_date >= m.join_date
    );
```
#### Output
| customer_id | first_order | product_name |
|-------------|-------------|--------------|
| B           | 2021-01-11  | sushi        |
| A           | 2021-01-07  | curry        |

### 7. Which item was purchased just before the customer became a member?
```sql
SELECT
    s.customer_id,
    s.order_date AS first_order,
    me.product_name
FROM sales s
JOIN members m ON s.customer_id = m.customer_id
JOIN menu me ON s.product_id = me.product_id
WHERE 
    s.order_date < m.join_date
    AND s.order_date = (
        SELECT Max(s2.order_date)
        FROM sales s2
        WHERE s2.customer_id = s.customer_id
        AND s2.order_date < m.join_date
    );
```
#### Output
| customer_id | first_order | product_name |
|-------------|-------------|--------------|
| B           | 2021-01-04  | sushi        |
| A           | 2021-01-01  | sushi        |
| A           | 2021-01-01  | curry        |


### 8. What is the total items and amount spent for each member before they became a member?
```sql
SELECT
    s.customer_id,
    COUNT(me.product_name) AS total_items,
    SUM(me.price) AS total_amount_spent
FROM sales s
JOIN members m ON s.customer_id = m.customer_id
JOIN menu me ON s.product_id = me.product_id 
WHERE s.order_date < m.join_date
GROUP BY s.customer_id;
```
#### Output
| customer_id | total_items | total_amount_spent |
|-------------|-------------|--------------------|
| B           |           3 |                 40 |
| A           |           2 |                 25 |

### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier, how many points would each customer have?
```sql
WITH points_table AS (
  SELECT *, 
   IF(product_name = 'sushi', price*20, price*10) AS points
  FROM menu
)
SELECT s.customer_id, SUM(points) AS points
FROM sales s
JOIN points_table p ON s.product_id = p.product_id
GROUP BY s.customer_id;
```
#### Output
| customer_id | points |
|-------------|--------|
| A           |    860 |
| B           |    940 |
| C           |    360 |


### 10. In the first week after a customer joins the program (including their join date), they earn 2x points on all items, not just sushi. How many points do customer A and B have at the end of January?
```sql
SELECT s.customer_id, 
  SUM(
   IF(s.order_date BETWEEN m.join_date AND DATE_ADD(m.join_date, INTERVAL 6 DAY), price*20, 
      IF(me.product_name = 'sushi', price*20, price*10)
      )
   ) AS total_points
FROM sales s
JOIN members m ON s.customer_id = m.customer_id
JOIN menu me ON s.product_id = me.product_id
WHERE MONTH(s.order_date) = 1
GROUP BY s.customer_id;
```
#### Output
| customer_id | total_points |
|-------------|--------------|
| B           |          820 |
| A           |         1370 |
