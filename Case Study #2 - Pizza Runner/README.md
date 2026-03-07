# Case Study #2 - Pizza Runner
<img src = "https://8weeksqlchallenge.com/images/case-study-designs/2.png" alt = "Image" width = "500" height="520">

Click **[here](https://8weeksqlchallenge.com/case-study-2/)** for more information about the Case Study.

## Introduction
Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

## Problem Statement
This case study has LOTS of questions - they are broken up by area of focus including:

- Pizza Metrics
- Runner and Customer Experience
- Ingredient Optimisation
- Pricing and Ratings
- Bonus DML Challenges (DML = Data Manipulation Language)

Each of the following case study questions can be answered using a single SQL statement.



## Entity Relationship Diagram
<img width="600" height="700" alt="image" src="https://github.com/user-attachments/assets/1f854321-050a-417e-8a79-f005ac2265bc" />

## Case Study Questions
### Pizza Metrics
1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?


## Data Cleaning & Transformation
When I first sat down with the raw data, it was clear that a fair bit of "janitor work" was needed before I could actually run any meaningful queries.

### My Approach: The "Clean Layer"
I decided not to touch the original tables. In a real-world production environment, you never want to overwrite your source of truth. Instead, I built a "Clean Layer", a set of new tables that are sanitized, correctly typed, and ready for analysis.

1. Fixing the `customer_orders` Table

   The biggest headache here was the inconsistent use of `'null'` as a string versus actual `NULL` values.

- The Fix: I used `NULLIF` to sweep through the `exclusions` and `extras` columns. Now, whether the data was an empty string or the word `"null"`, it’s stored as a proper database `NULL`.

- Why? This makes it way easier to count how many customers actually requested changes without writing complex `WHERE` clauses.

2. Scrubbing the `runner_orders` Table

   This table was the "messiest." It had units mixed in with numbers (like "20km" or "32 minutes"), which makes math impossible.

- `distance`: I stripped out the `"km"` and whitespace, then cast it to a `DECIMAL`. Now we can actually calculate things like total distance covered.

- `duration`: I did the same for `"mins"` and `"minutes"`, turning them into `INTEGER` values.

- The "Unsigned" Gotcha: MySQL defaults to `BIGINT UNSIGNED` when you create a table from a select statement. To keep the schema clean and predictable, I manually `ALTERED` this back to a standard `INTEGER`.

3. Normalizing `pizza_recipes` (The 1NF Move)

   The original `pizza_recipes` table had a major design flaw: it stored toppings as a comma-separated list (e.g., "1, 2, 3"). This is a nightmare for joins.

- The Transformation: I used a `Recursive CTE` to unnest those strings.

- The Result: I moved the data into First Normal Form (1NF). Each topping now has its own row. This took the table from a "flat list" to a relational structure that can easily join with the `pizza_toppings` table.

4. General Schema Polish

   Finally, I cleaned up the data types for the `pizza_names` and `pizza_toppings` tables.

- Text vs. Varchar: I swapped `TEXT` for `VARCHAR(50)`. Since these are just short names (like "Pepperoni" or "Meatlovers"), `TEXT` is overkill. `VARCHAR` is more efficient for storage and much faster for indexing.
