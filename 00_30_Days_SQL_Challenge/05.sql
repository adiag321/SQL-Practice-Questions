-- Day 05/30 days SQL challenge
/*
-- UBER DATA ANALYST INTERVIEW QUESTION
Question:
Write a SQL query to obtain the third transaction of every user. Output the user id, spend, and transaction date.
*/

-- SCHEMAS
-- Create transactions table
CREATE TABLE transactions (
    user_id INTEGER,
    spend DECIMAL(10, 2),
    transaction_date TIMESTAMP
);
INSERT INTO transactions (user_id, spend, transaction_date) VALUES
(111, 100.50, '2022-01-08 12:00:00'),
(111, 55.00, '2022-01-10 12:00:00'),
(121, 36.00, '2022-01-18 12:00:00'),
(145, 24.99, '2022-01-26 12:00:00'),
(111, 89.60, '2022-02-05 12:00:00');

-- ----------------------------------------------
-- My solution
-- ----------------------------------------------

SELECT 
  user_id,
  spend,
  transaction_date
FROM 
    (
      SELECT 
        user_id,
        spend,
        transaction_date,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) as rn
    FROM transactions) x1
WHERE rn = 3

-- ----------------------------------------------
-- Question 2
-- ----------------------------------------------
/*
Question:
Find the top 5 products whose revenue has decreased in comparison to the previous year (both 2022 and 2023). Return the product name, 
revenue for the previous year, revenue for the current year, revenue decreased, and the decreased ratio (percentage).
*/

-- Create product_revenue table
CREATE TABLE product_revenue (
    product_name VARCHAR(255),
    year INTEGER,
    revenue DECIMAL(10, 2)
);
INSERT INTO product_revenue (product_name, year, revenue) VALUES
('Product A', 2022, 10000.00),
('Product A', 2023, 9500.00),
('Product B', 2022, 15000.00),
('Product B', 2023, 14500.00),
('Product C', 2022, 8000.00),
('Product C', 2023, 8500.00),
('Product D', 2022, 12000.00),
('Product D', 2023, 12500.00),
('Product E', 2022, 20000.00),
('Product E', 2023, 19000.00),
('Product F', 2022, 7000.00),
('Product F', 2023, 7200.00),
('Product G', 2022, 18000.00),
('Product G', 2023, 17000.00),
('Product H', 2022, 3000.00),
('Product H', 2023, 3200.00),
('Product I', 2022, 9000.00),
('Product I', 2023, 9200.00),
('Product J', 2022, 6000.00),
('Product J', 2023, 5900.00);

-- ----------------------------------------------
-- My solution
-- ----------------------------------------------

-- SOLUTION 1:
WITH revenue_comparison AS (
    SELECT 
        product_name,
        year,
        revenue,
        LAG(revenue) OVER (PARTITION BY product_name ORDER BY year) AS prev_year_revenue
    FROM product_revenue
),
rev_comp as (
    SELECT 
    product_name,
    prev_year_revenue AS previous_year_revenue,
    revenue AS current_year_revenue,
    (prev_year_revenue - revenue) AS revenue_decreased,
    ((prev_year_revenue - revenue) / prev_year_revenue) * 100 AS decreased_ratio_percentage
FROM revenue_comparison
WHERE prev_year_revenue IS NOT NULL
ORDER BY revenue_decreased DESC
)
SELECT *
FROM rev_comp
WHERE revenue_decreased > 0
LIMIT 5;

-- SOLUTION 2:
WITH PREV_REV AS (
  SELECT
    *,
    LAG(REVENUE) OVER(PARTITION BY PRODUCT_NAME ORDER BY YEAR) AS PREV_REV
    FROM PRODUCT_REVENUE
),
REV_COMP AS (
    SELECT
    *,
    PREV_REV - REVENUE AS REVENUE_DECREASED,
    CASE WHEN REVENUE < PREV_REV THEN 1 ELSE 0 END AS REV_DECRE_IND,
    ROUND(((PREV_REV - REVENUE)/PREV_REV)*100.0,2) AS REV_DECREASED_RATIO
    FROM PREV_REV
)
SELECT
PRODUCT_NAME,
REVENUE AS CUR_YR_REV,
PREV_REV,
REVENUE_DECREASED,
REV_DECREASED_RATIO
FROM REV_COMP
WHERE REV_DECRE_IND = 1;

