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


## Data cleaning
When I first saw the data, I knew it needed some cleaning. I could either alter the existing table or create a new one. 
Both are valid approaches, but I didn't want to touch the original table, so I created a new, clean table in the same database. 
This approach keeps the raw data untouched and organized.

For `pizza_recipes` table, I realized the data required cleaning and structural adjustments. To ensure data integrity, I performed 1NF normalization to eliminate multi-valued attributes.
