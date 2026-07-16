## Amazon SQL Data Analytics Interview Questions

All 15 questions use the following database schema. Create and insert all tables before running individual question solutions.

* Assumed current date: 2026-03-16

#### Create and Insert Statements

```sql
-- TABLE 1: customers
-- Used by: Q6, Q11, Q15
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

-- TABLE 2: products
-- Used by: Q2, Q6, Q9
-- NOTE: product_id 999 is intentionally MISSING here → used in
--       sales table to test Q9 (ghost/orphan products)
CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100),
    category     VARCHAR(50)
);

-- TABLE 3: purchases
-- Used by: Q1, Q6, Q11
-- NOTE: same customer can have multiple rows (one per purchase)
CREATE TABLE purchases (
    purchase_id   INT PRIMARY KEY,
    customer_id   INT,
    product_id    INT,
    purchase_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id)
);

-- TABLE 4: sales
-- Used by: Q2, Q3, Q7, Q9, Q13, Q14
-- Columns: store_id (Q7,Q14), product_id (Q2,Q3,Q9,Q13),
--          sale_amount, sale_date
CREATE TABLE sales (
    sale_id     INT PRIMARY KEY,
    store_id    INT,
    product_id  INT,
    sale_amount DECIMAL(10,2),
    sale_date   DATE
);

-- TABLE 5: employees
-- Used by: Q4, Q5, Q8
-- NOTE: employee_id is NOT unique here — one employee can appear
--       in multiple rows with different department_ids to simulate
--       working across departments (needed for Q4)
CREATE TABLE employees (
    row_id        INT PRIMARY KEY,   -- surrogate key
    employee_id   INT  NOT NULL,
    name          VARCHAR(100),
    manager_id    INT  NULL,         -- NULL = this person is a top-level manager
    department_id INT,
    salary        DECIMAL(10,2)
);

-- TABLE 6: deliveries
-- Used by: Q10
CREATE TABLE deliveries (
    delivery_id   INT PRIMARY KEY,
    supplier_id   INT,
    order_date    DATE,
    delivery_date DATE,
    quantity      INT
);

-- TABLE 7: order_details
-- Used by: Q12
CREATE TABLE order_details (
    order_id   INT,
    product_id INT,
    PRIMARY KEY (order_id, product_id)
);

-- TABLE 8: orders
-- Used by: Q15
CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    order_date  DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

------------------------------------------------------------------------
-- INSERT STATEMENTS
-- customers
INSERT INTO customers VALUES
(1, 'Alice Johnson'),   
(2, 'Bob Smith'),       
(3, 'Carol White'),     
(4, 'David Brown'),     
(5, 'Eva Martinez'), 
(6, 'Frank Lee');      

-- products (3 categories: Electronics, Clothing, Books)
INSERT INTO products VALUES
(101, 'iPhone 15',   'Electronics'),
(102, 'MacBook Pro', 'Electronics'),
(103, 'T-Shirt',     'Clothing'),
(104, 'Jeans',       'Clothing'),
(105, 'Novel',       'Books'),
(106, 'Textbook',    'Books');

-- purchases
INSERT INTO purchases VALUES
(1001, 1, 101, '2026-02-18'),   
(1002, 1, 103, '2026-02-25'), 
(1003, 1, 105, '2026-03-05'),   
(1004, 1, 106, '2026-03-05'),   
(1005, 2, 102, '2026-02-20'),
(1006, 2, 104, '2026-03-02'),
(1007, 3, 101, '2026-02-17'),
(1008, 3, 102, '2026-02-24'),
(1009, 3, 103, '2026-03-03'),
(1010, 3, 105, '2026-03-12'),
(1011, 4, 101, '2025-05-10'),
(1012, 4, 105, '2025-08-20'),
(1013, 5, 103, '2025-07-15'), 
(1014, 5, 102, '2025-11-30');  

-- sales
INSERT INTO sales VALUES
(1,  1, 101, 1200.00, '2026-01-01'),
(2,  1, 101, 1100.00, '2026-01-02'),
(3,  1, 101,  950.00, '2026-01-03'),
(4,  1, 101, 1050.00, '2026-01-04'),
(5,  1, 101, 1300.00, '2026-01-05'),
(6,  1, 101,  980.00, '2026-01-06'),
(7,  1, 101, 1150.00, '2026-01-07'),
(8,  1, 101,  480.00, '2026-01-08'),
(9,  1, 102, 2200.00, '2026-01-01'),
(10, 1, 102, 1900.00, '2026-01-02'),
(11, 1, 102, 2100.00, '2026-01-03'),
(12, 1, 102, 2050.00, '2026-01-04'),
(13, 1, 102, 2300.00, '2026-01-05'),
(14, 1, 102, 1950.00, '2026-01-06'),
(15, 1, 102, 2000.00, '2026-01-07'),
(16, 1, 102,  900.00, '2026-01-08'),
(17, 1, 103,  700.00, '2026-01-10'),
(18, 1, 103,  650.00, '2026-01-20'),
(19, 1, 103,  720.00, '2026-02-05'),
(20, 1, 104,  450.00, '2026-01-10'),
(21, 1, 104,  480.00, '2026-01-20'),
(22, 1, 104,  500.00, '2026-02-05'),
(23, 1, 105,  320.00, '2026-01-10'),
(24, 1, 105,  300.00, '2026-01-25'),
(25, 1, 105,  310.00, '2026-02-10'),
(26, 1, 106,  400.00, '2026-01-10'),
(27, 1, 106,  380.00, '2026-01-25'),
(28, 1, 106,  420.00, '2026-02-10'),
(50, 1, 101, 1500.00, '2026-02-01'),  
(51, 1, 101, 1600.00, '2026-02-15'),
(52, 1, 102, 2400.00, '2026-02-01'),
(53, 1, 102, 2300.00, '2026-02-20'),
(54, 1, 103,  300.00, '2026-02-25'),
(29, 2, 101,  950.00, '2026-01-05'),
(30, 2, 101, 1100.00, '2026-01-15'),
(31, 2, 101, 1050.00, '2026-02-05'),
(32, 2, 102, 1800.00, '2026-01-05'),
(33, 2, 102, 2100.00, '2026-01-15'),
(34, 2, 102, 1950.00, '2026-02-10'),
(35, 2, 103,  620.00, '2026-01-10'),
(36, 2, 103,  580.00, '2026-02-05'),
(37, 2, 104,  500.00, '2026-01-10'),
(38, 2, 105,  320.00, '2026-01-20'),
(39, 2, 106,  360.00, '2026-02-10'),
(40, 3, 101,  800.00, '2026-01-05'),
(41, 3, 101,  900.00, '2026-02-05'),
(42, 3, 102, 2500.00, '2026-01-05'),
(43, 3, 102, 2300.00, '2026-02-10'),
(44, 3, 103,  700.00, '2026-01-10'),
(45, 3, 104,  600.00, '2026-01-10'),
(46, 3, 105,  400.00, '2026-02-05'),
(47, 3, 106,  450.00, '2026-02-15'),
(55, 1, 999,  100.00, '2026-01-10'),
(56, 2, 999,  150.00, '2026-02-05'),
(57, 3, 999,  120.00, '2026-02-20');

-- employees
INSERT INTO employees VALUES
(1,  1,  'Sarah Connor',  NULL, 1, 95000.00),
(2,  2,  'John Miller',   NULL, 2, 90000.00),
(3,  3,  'Lisa Chen',     NULL, 3, 98000.00),
(4,  4,  'Mike Davis',    1,    1, 85000.00),
(5,  5,  'Anna Wilson',   1,    1, 70000.00),
(6,  6,  'Tom Brown',     1,    1, 75000.00),
(7,  7,  'Jake Lee',      2,    2, 88000.00),
(8,  8,  'Emma White',    2,    2, 72000.00),
(9,  9,  'Chris Hall',    3,    3, 92000.00),
(10, 10, 'Ryan Scott',    1,    1, 78000.00),
(11, 10, 'Ryan Scott',    1,    2, 78000.00),
(12, 11, 'Nina Patel',    2,    2, 80000.00),
(13, 11, 'Nina Patel',    2,    3, 80000.00);

-- deliveries
INSERT INTO deliveries VALUES
(1, 1, '2026-01-01', '2026-01-02', 150),
(2, 1, '2026-01-05', '2026-01-06', 200),
(3, 1, '2026-01-10', '2026-01-11', 120),
(4, 1, '2026-02-01', '2026-02-02', 180),
(5, 2, '2026-01-01', '2026-01-04', 130),
(6, 2, '2026-01-10', '2026-01-13', 160),
(7, 2, '2026-02-01', '2026-02-05', 110),
(8, 3, '2026-01-01', '2026-01-02',  80),
(9, 3, '2026-01-10', '2026-01-11',  50);

-- order_details
INSERT INTO order_details VALUES
(1, 101), (1, 102), (1, 103),
(2, 101), (2, 102),
(3, 101), (3, 102), (3, 103),
(4, 101), (4, 103),
(5, 101), (5, 102),
(6, 102), (6, 103),
(7, 104), (7, 105),
(8, 104), (8, 106);

-- orders
INSERT INTO orders VALUES
(101, 1, '2026-02-20'),
(102, 1, '2026-03-01'),
(103, 1, '2026-03-10'),
(104, 1, '2025-11-15'),
(201, 2, '2026-03-05'),
(202, 2, '2025-10-10'),
(203, 2, '2025-11-20'),
(204, 2, '2026-01-05'),
(601, 6, '2026-02-18'),
(602, 6, '2026-03-12'),
(603, 6, '2025-12-01');
```

---

## Questions

#### Question 1: Identify customers who made purchases on exactly 3 different days in the last month

Find all customers who have exactly 3 distinct purchase dates within the last 30 days (from 2026-02-16 to 2026-03-16).

Solution:
```sql
SELECT
  customer_id,
  COUNT(DISTINCT purchase_date) AS diff_pur_dates
FROM purchases
WHERE purchase_date BETWEEN ('2026-03-16' - INTERVAL 30 DAY) AND '2026-03-16'
GROUP BY customer_id
HAVING COUNT(DISTINCT purchase_date) = 3;
```

---

#### Question 2: Find the top 2 highest-selling products for each category

Identify the top 2 products by total sales amount within each product category.

Solution:
```sql
WITH cte AS (
  SELECT
    temp.*,
    DENSE_RANK() OVER(PARTITION BY category ORDER BY total_sales DESC) AS rnk
  FROM (
    SELECT
      p.category,
      p.product_name,
      SUM(s.sale_amount) AS total_sales
    FROM products AS p
    JOIN sales AS s ON p.product_id = s.product_id
    GROUP BY p.category, p.product_name
  ) AS temp
)
SELECT * FROM cte WHERE rnk <= 2;
```

---

#### Question 3: Detect anomalies where sales for a product are 50% lower than that product's average

Find sales records where the sale amount is at most 50% of that product's average sale amount.

Solution:
```sql
WITH cte AS (
  SELECT
    product_id,
    AVG(sale_amount) AS avg_sales
  FROM sales
  GROUP BY product_id
)
SELECT
  s.*,
  c.avg_sales
FROM sales AS s
JOIN cte AS c ON s.product_id = c.product_id
WHERE sale_amount <= 0.5 * avg_sales;
```

---

#### Question 4: Find employees who have never been a manager and worked in more than one department

Identify employees who are never listed as a manager for anyone AND who have worked in 2 or more departments.

Solution:
```sql
SELECT
  e2.employee_id,
  COUNT(DISTINCT e2.department_id) AS dist_employee_dept
FROM employees AS e1
JOIN employees AS e2 ON e1.employee_id = e2.manager_id
GROUP BY e2.employee_id
HAVING COUNT(DISTINCT e2.department_id) >= 2;
```

---

#### Question 5: Calculate the median salary in each department (IMPORTANT)

Compute the median salary for each department.

Solution:
```sql
WITH cte AS (
  SELECT
    department_id,
    salary,
    ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary ASC) AS row_nm,
    COUNT(*) OVER(PARTITION BY department_id) AS cnt
  FROM employees
)
SELECT
  department_id,
  AVG(salary) AS median_salary
FROM cte
WHERE row_nm IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2))
GROUP BY department_id, salary
ORDER BY department_id;
```

---

#### Question 6: Identify customers who purchased products from all available categories

Find all customers who have made purchases covering every product category in the database.

Solution:
```sql
SELECT
  pur.customer_id
FROM purchases AS pur
JOIN products AS prod ON pur.product_id = prod.product_id
GROUP BY pur.customer_id
HAVING COUNT(DISTINCT prod.category) = (SELECT COUNT(DISTINCT category) FROM products)
ORDER BY pur.customer_id;
```

---

#### Question 7: Calculate cumulative sales per store, but only on days sales exceeded the store's daily average (IMPORTANT)

Show cumulative running sales for each store, including only those individual sales that exceeded that day's average for that store.

Solution:
```sql
WITH daily_avg_sales AS (
  SELECT
    store_id,
    sale_date,
    AVG(sale_amount) AS avg_daily_sales
  FROM sales
  GROUP BY store_id, sale_date
)
SELECT
  s.*,
  avg_sal.avg_daily_sales,
  SUM(sale_amount) OVER(PARTITION BY store_id ORDER BY sale_date) AS cum_sales
FROM sales AS s
JOIN daily_avg_sales AS avg_sal
  ON s.store_id = avg_sal.store_id
  AND s.sale_date = avg_sal.sale_date
WHERE sale_amount > avg_sal.avg_daily_sales
ORDER BY s.store_id, s.sale_date;
```

---

#### Question 8: List employees who earn more than their department average

Find employees whose individual salary exceeds the average salary in their department.

Solution:
```sql
WITH dept_sal AS (
  SELECT
    department_id,
    AVG(salary) AS dept_avg_sal
  FROM employees
  GROUP BY department_id
)
SELECT
  e.employee_id,
  e.name,
  e.department_id,
  e.salary,
  d.dept_avg_sal
FROM employees AS e
JOIN dept_sal AS d ON e.department_id = d.department_id
WHERE e.salary >= d.dept_avg_sal;
```

---

#### Question 9: Identify products that were sold but have no record in the products table, and count how many times each was sold

Find "ghost" products — those that appear in sales records but don't exist in the products table — and count their occurrences.

Solution:
```sql
SELECT
  product_id,
  COUNT(DISTINCT sale_id) AS times_sold
FROM sales
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM products)
GROUP BY product_id;
```

---

#### Question 10: Find suppliers whose avg delivery time < 2 days, considering only deliveries with quantity > 100

Identify fast suppliers who consistently deliver in fewer than 2 days, filtering for only large orders (quantity > 100).

Solution:
```sql
SELECT
  supplier_id,
  AVG(delivery_date - order_date) AS time_to_deliver
FROM deliveries
WHERE quantity > 100
GROUP BY supplier_id
HAVING AVG(delivery_date - order_date) < 2;
```

---

#### Question 11: Find customers with no purchases in last 6 months but at least one in the 6 months before that

Identify "churned" customers — those who purchased 6–12 months ago but have been inactive in the last 6 months.

Solution:
```sql
WITH six_months_ago AS (
  SELECT
    customer_id
  FROM purchases
  WHERE purchase_date <= ('2026-03-16' - INTERVAL 6 MONTH)
  GROUP BY customer_id
  HAVING COUNT(DISTINCT purchase_id) >= 1
),
recent_purchases AS (
  SELECT DISTINCT
    customer_id
  FROM purchases
  WHERE purchase_date BETWEEN ('2026-03-16' - INTERVAL 6 MONTH) AND '2026-03-16'
)
SELECT *
FROM six_months_ago
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM recent_purchases);
```

---

#### Question 12: Find the top 3 most frequent product combinations bought together (IMPORTANT)

Identify which pairs of products are most commonly purchased together and rank the top 3 by frequency.

Solution:
```sql
SELECT
  o1.product_id AS prod1,
  o2.product_id AS prod2,
  COUNT(*) AS prod_cnt
FROM order_details AS o1
JOIN order_details AS o2
  ON o1.order_id = o2.order_id
  AND o1.product_id < o2.product_id
GROUP BY o1.product_id, o2.product_id
ORDER BY prod_cnt DESC
LIMIT 3;
```

---

#### Question 13: Calculate the 7-day moving average of sales for each product (IMPORTANT)

Compute a rolling 7-day average of sales amounts for each product, ordered by sale date.

Solution:
```sql
SELECT
  product_id,
  sale_date,
  sale_amount,
  AVG(sale_amount) OVER(
    PARTITION BY product_id
    ORDER BY sale_date ASC
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS moving_avg
FROM sales
ORDER BY product_id, sale_date;
```

---

#### Question 14: Rank stores by their monthly sales performance

Rank stores within each month by their total monthly sales, identifying the top-performing store per month.

Solution:
```sql
WITH mnthly_store_perf AS (
  SELECT
    store_id,
    EXTRACT(MONTH FROM sale_date) AS mnth,
    SUM(sale_amount) AS total_sales,
    COUNT(product_id) AS products_sold
  FROM sales
  GROUP BY store_id, EXTRACT(MONTH FROM sale_date)
),
rnking AS (
  SELECT
    *,
    DENSE_RANK() OVER(PARTITION BY mnth ORDER BY total_sales DESC) AS rnk
  FROM mnthly_store_perf
)
SELECT DISTINCT
  store_id
FROM rnking
WHERE rnk = 1;
```

---

#### Question 15: Find customers who placed more than 50% of their orders in the last month

Identify customers whose order volume in the last month represents more than half of their total lifetime orders.

Solution:
```sql
WITH total_placed_orders AS (
  SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
  FROM orders
  GROUP BY customer_id
),
total_placed_orders_last_mnth AS (
  SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders_last_mnth
  FROM orders
  WHERE order_date BETWEEN ('2026-03-16' - INTERVAL 1 MONTH) AND '2026-03-16'
  GROUP BY customer_id
)
SELECT
  t1.customer_id
FROM total_placed_orders AS t1
JOIN total_placed_orders_last_mnth AS t2 ON t1.customer_id = t2.customer_id
WHERE t2.total_orders_last_mnth >= 0.5 * t1.total_orders;
```
