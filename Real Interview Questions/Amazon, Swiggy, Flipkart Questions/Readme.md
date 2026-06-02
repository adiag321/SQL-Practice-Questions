# SQL Interview Questions and Solutions

This repository contains common SQL interview questions from top tech companies along with their solutions.

## Table of Contents
- [Angel One - Find Users Whose Salary Increased by 10% from Last Year](#angel-one---find-users-whose-salary-increased-by-10-from-last-year)
- [Amazon - Find the Second Highest Salary](#amazon---find-the-second-highest-salary)
- [Google - Find Users Who Made Purchases on 3 Consecutive Days](#google---find-users-who-made-purchases-on-3-consecutive-days)
- [Flipkart - Get Product with Highest Total Revenue](#flipkart---get-product-with-highest-total-revenue)
- [Swiggy - Rank Restaurants by Daily Orders](#swiggy---rank-restaurants-by-daily-orders)

## Angel One - Find Users Whose Salary Increased by 10% from Last Year

### Problem
Find employees whose salary increased exactly by 10% from the previous year.

### Dataset
```sql
CREATE TABLE employees (
  emp_id INT,
  emp_name VARCHAR(50),
  salary INT,
  year INT
);

INSERT INTO employees VALUES 
(1, 'Alice', 70000, 2022),
(2, 'Bob', 80000, 2022),
(3, 'Charlie', 90000, 2022),
(1, 'Alice', 77000, 2023),
(2, 'Bob', 88000, 2023),
(3, 'Charlie', 99000, 2023);
```

### Solution
```sql
SELECT a.emp_id, a.emp_name 
FROM employees a 
JOIN employees b ON a.emp_id = b.emp_id AND a.year = b.year-1 
WHERE a.salary * 1.1 = b.salary;
```
--------------------

## Amazon - Find the Second Highest Salary

### Problem
Find the employee with the second highest salary.

### Dataset
```sql
CREATE TABLE employees (
  emp_id INT,
  emp_name VARCHAR(50),
  salary INT,
  year INT
);

INSERT INTO employees VALUES 
(1, 'Alice', 70000, 2022),
(2, 'Bob', 80000, 2022),
(3, 'Charlie', 90000, 2022),
(1, 'Alice', 77000, 2023),
(2, 'Bob', 88000, 2023),
(3, 'Charlie', 99000, 2023);
```

### Solution
```sql
WITH cte AS (
  SELECT *, 
  DENSE_RANK() OVER(ORDER BY salary DESC) AS rk 
  FROM employees
) 
SELECT * FROM cte WHERE rk = 2;
```
--------------------

## Google - Find Users Who Made Purchases on 3 Consecutive Days

### Problem
Identify users who made purchases on three consecutive days.

### Dataset
```sql
CREATE TABLE purchases (
  user_id INT,
  purchase_date DATE
);

INSERT INTO purchases VALUES 
(101, '2024-04-01'),
(101, '2024-04-02'),
(101, '2024-04-03'),
(102, '2024-04-01'),
(102, '2024-04-03'),
(103, '2024-04-01'),
(103, '2024-04-02'),
(103, '2024-04-04');
```

### Solution
```sql
WITH cte AS (
  SELECT *, 
  LEAD(purchase_date, 1) OVER(PARTITION BY user_id ORDER BY purchase_date) AS next_day,
  LEAD(purchase_date, 2) OVER(PARTITION BY user_id ORDER BY purchase_date) AS day_after_next_day
  FROM purchases
)
SELECT user_id 
FROM cte 
WHERE DATEDIFF(day, purchase_date, next_day) = 1 
  AND DATEDIFF(day, purchase_date, day_after_next_day) = 2;
```
--------------------

## Flipkart - Get Product with Highest Total Revenue

### Problem
Find the product that generated the highest total revenue.

### Dataset
```sql
CREATE TABLE orders (
  order_id INT,
  product_id INT,
  restaurant_id INT,
  price INT,
  quantity INT,
  order_date DATE
);

INSERT INTO orders VALUES 
(1, 101, 201, 100, 2, '2024-04-01'),
(2, 102, 202, 150, 1, '2024-04-01'),
(3, 101, 201, 100, 3, '2024-04-02'),
(4, 103, 202, 200, 1, '2024-04-02'),
(5, 102, 203, 150, 2, '2024-04-03');
```

### Solution
```sql
WITH cte AS (
  SELECT product_id, SUM(price * quantity) AS total_revenue 
  FROM orders 
  GROUP BY product_id
),
cte2 AS (
  SELECT MAX(total_revenue) maximum 
  FROM cte
)
SELECT product_id 
FROM cte, cte2 
WHERE total_revenue = maximum;
```
--------------------

## Swiggy - Rank Restaurants by Daily Orders

### Problem
Rank restaurants by their daily order quantities.

### Dataset
```sql
CREATE TABLE orders (
  order_id INT,
  product_id INT,
  restaurant_id INT,
  price INT,
  quantity INT,
  order_date DATE
);

INSERT INTO orders VALUES 
(1, 101, 201, 100, 2, '2024-04-01'),
(2, 102, 202, 150, 1, '2024-04-01'),
(3, 101, 201, 100, 3, '2024-04-02'),
(4, 103, 202, 200, 1, '2024-04-02'),
(5, 102, 203, 150, 2, '2024-04-03');
```

### Solution
```sql
SELECT *, 
DENSE_RANK() OVER(PARTITION BY order_date ORDER BY quantity DESC) AS ranking 
FROM orders;
```