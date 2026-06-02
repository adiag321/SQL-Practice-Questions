# SQL Functions Reference Guide

## 1. Window Functions

### Ranking Functions
| Function | Syntax | Ties Handling |
| :--- | :--- | :--- |
| **`ROW_NUMBER()`** | `ROW_NUMBER() OVER(...)` | Unique sequential integer |
| **`RANK()`** | `RANK() OVER(...)` | Same rank for ties |
| **`DENSE_RANK()`** | `DENSE_RANK() OVER(...)` | Same rank for ties |

<details>
<summary><b>View Ranking Examples</b></summary>

```sql
-- 1. ROW_NUMBER: Find the 3rd transaction of every user (Uber) File: 30_Days_SQL_Challenge/05.sql
SELECT user_id, spend, transaction_date
FROM (
    SELECT user_id, spend, transaction_date,
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rn
    FROM transactions
) x1
WHERE rn = 3;

-- 2. DENSE_RANK: Top 3 salary earners in each department (LeetCode) File: 30_Days_SQL_Challenge/09.sql
SELECT department_name, emp_name, salary
FROM (
    SELECT d.name AS department_name, e.name AS emp_name, e.salary,
           DENSE_RANK() OVER(PARTITION BY d.name ORDER BY e.salary DESC) AS drn
    FROM employee e
    JOIN department d ON e.departmentId = d.id
) x1
WHERE drn <= 3;

-- 3. RANK: First year each product was sold (Walmart) File: 30_Days_SQL_Challenge/29.sql
SELECT product_id, first_year, quantity, price
FROM (
    SELECT product_id,
           year AS first_year,
           quantity,
           price,
           RANK() OVER(PARTITION BY product_id ORDER BY year) AS rn
    FROM sales
) AS temp
WHERE rn = 1;
```
</details>

### Value & Analytics Functions
| Function | Syntax | Purpose / Use Case |
| :--- | :--- | :--- |
| **`LAG(col, offset)`** | `LAG(col) OVER(...)` | Returns value from **previous** row (Period-over-Period comparisons) |
| **`LEAD(col, offset)`** | `LEAD(col) OVER(...)` | Returns value from **next** row |
| **`SUM() OVER()`** | `SUM(col) OVER(...)` | Running / Cumulative Total |
| **`AVG() OVER()`** | `AVG(col) OVER(...)` | Moving Average (using `ROWS BETWEEN ...`) |

<details>
<summary><b>View Value/Analytics Examples</b></summary>

```sql
-- 1. LAG: Compare product revenue to previous year (Amazon) File: 30_Days_SQL_Challenge/05.sql
WITH prev_rev AS (
    SELECT *,
        LAG(revenue) OVER(PARTITION BY product_name ORDER BY year) AS prev_year_revenue
    FROM product_revenue
)
SELECT product_name, revenue AS current_year_revenue, prev_year_revenue,
       ROUND(((prev_year_revenue - revenue) / prev_year_revenue) * 100.0, 2) AS pct_decrease
FROM prev_rev
WHERE prev_year_revenue > revenue;

-- 2. Moving Average: 3-day rolling average (General pattern)
SELECT order_date, amount,
       AVG(amount) OVER(
           PARTITION BY user_id
           ORDER BY order_date
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS moving_avg_3day
FROM orders;

-- 3. Running Total (Cumulative SUM): Revenue per product over time (Flipkart)  File: 30_Days_SQL_Challenge/25.sql
SELECT
    date,
    product_id,
    product_name,
    revenue,
    SUM(revenue) OVER (PARTITION BY product_id ORDER BY date) AS running_total
FROM orders
ORDER BY product_id, date;
```
</details>

---

## 2. Date & Time Functions

### MySQL
| Scenario | Syntax | Short Example |
| :--- | :--- | :--- |
| **1. Extract Part from Date** | `EXTRACT(unit FROM date)` <br> *Shorthands:* `YEAR(date)`, `MONTH(date)`, `DAY(date)` | `SELECT EXTRACT(MONTH FROM '2026-05-22');`<br>`SELECT YEAR('2026-05-22');` |
| **2. Format Part of Date** | `DATE_FORMAT(date, format_string)` | `SELECT DATE_FORMAT('2026-05-22', '%Y-%m');` |
| **3. Get Current Date** | `CURRENT_DATE()` or `CURDATE()` <br> `NOW()` or `CURRENT_TIMESTAMP()` | `SELECT CURRENT_DATE();`<br>`SELECT NOW();` |
| **4. Date Differences** | `DATEDIFF(date1, date2)` *(date1 - date2 in days)*<br>`TIMESTAMPDIFF(unit, datetime1, datetime2)` | `SELECT DATEDIFF('2026-05-22', '2026-05-15');`<br>`SELECT TIMESTAMPDIFF(MONTH, '2026-01-01', '2026-05-01');` |
| **5. Rolling / Moving Windows** | **Arithmetic:** `date + INTERVAL expr unit`<br>**Window:** `RANGE BETWEEN INTERVAL expr unit PRECEDING AND CURRENT ROW` | `SELECT '2026-05-22' + INTERVAL 7 DAY;`<br>`AVG(val) OVER(ORDER BY dt RANGE BETWEEN INTERVAL 2 DAY PRECEDING AND CURRENT ROW)` |
| **6. DATE_TRUNC (Truncation)** | *Not native.* Simulated using:<br>`DATE_FORMAT(date, '%Y-%m-01')` or `STR_TO_DATE(...)` | `SELECT DATE_FORMAT('2026-05-22', '%Y-%m-01');`<br>`SELECT DATE_FORMAT('2026-05-22', '%Y-01-01');` |

---

### PostgreSQL
| Scenario | Syntax | Short Example |
| :--- | :--- | :--- |
| **1. Extract Part from Date** | `EXTRACT(field FROM source)` <br> `date_part('field', source)` | `SELECT EXTRACT(MONTH FROM DATE '2026-05-22');`<br>`SELECT date_part('year', TIMESTAMP '2026-05-22');` |
| **2. Format Part of Date** | `TO_CHAR(source, format_string)` | `SELECT TO_CHAR(TIMESTAMP '2026-05-22', 'YYYY-MM');` |
| **3. Get Current Date** | `CURRENT_DATE`<br>`CURRENT_TIMESTAMP` or `NOW()` | `SELECT CURRENT_DATE;`<br>`SELECT NOW();` |
| **4. Date Differences** | `date1 - date2` *(returns days as integer)*<br>`AGE(timestamp1, timestamp2)` *(returns human-readable interval)* | `SELECT DATE '2026-05-22' - DATE '2026-05-15';`<br>`SELECT AGE(TIMESTAMP '2026-05-22', TIMESTAMP '2026-01-01');` |
| **5. Rolling / Moving Windows** | **Arithmetic:** `date + INTERVAL 'expr unit'`<br>**Window:** `RANGE BETWEEN INTERVAL 'expr unit' PRECEDING AND CURRENT ROW` | `SELECT DATE '2026-05-22' + INTERVAL '7 days';`<br>`AVG(val) OVER(ORDER BY dt RANGE BETWEEN INTERVAL '2 days' PRECEDING AND CURRENT ROW)` |
| **6. DATE_TRUNC (Truncation)** | `DATE_TRUNC('field', source)` | `SELECT DATE_TRUNC('month', DATE '2026-05-22');`<br>`SELECT DATE_TRUNC('year', DATE '2026-05-22');` |

---

### SQLite
| Scenario | Syntax | Short Example |
| :--- | :--- | :--- |
| **1. Extract Part from Date** | `strftime(format, date)` <br> *Shorthand:* `unixepoch(date)` *(for unix timestamp)* | `SELECT strftime('%m', '2026-05-22');`<br>`SELECT CAST(strftime('%Y', '2026-05-22') AS INTEGER);` |
| **2. Format Part of Date** | `strftime(format, date)` | `SELECT strftime('%Y-%m', '2026-05-22');` |
| **3. Get Current Date** | `date('now')` or `CURRENT_DATE`<br>`datetime('now')` or `CURRENT_TIMESTAMP` | `SELECT date('now');`<br>`SELECT datetime('now');` |
| **4. Date Differences** | `julianday(date1) - julianday(date2)` *(returns fractional days)*<br>`unixepoch(date1) - unixepoch(date2)` *(seconds difference)* | `SELECT julianday('2026-05-22') - julianday('2026-05-15');`<br>`SELECT unixepoch('2026-05-22') - unixepoch('2026-05-15');` |
| **5. Rolling / Moving Windows** | **Arithmetic:** `date(date, 'value unit')`<br>**Window:** Convert dates to integer epochs and use `RANGE BETWEEN seconds PRECEDING AND CURRENT ROW` | `SELECT date('2026-05-22', '+7 days');`<br>`AVG(val) OVER(ORDER BY unixepoch(dt) RANGE BETWEEN 172800 PRECEDING AND CURRENT ROW)` |
| **6. DATE_TRUNC (Truncation)** | *Not native.* Simulated using:<br>`date(date, 'start of month')` or `strftime('%Y-%m-01', date)` | `SELECT date('2026-05-22', 'start of month');`<br>`SELECT date('2026-05-22', 'start of year');` |

<details>
<summary><b>View Comprehensive Date & Time Dialect Examples</b></summary>

#### 1. Extracting Month/Year
```sql
-- MySQL / PostgreSQL (standard EXTRACT)
SELECT EXTRACT(MONTH FROM submit_date) AS month, product_id, ROUND(AVG(stars), 2) AS avg_rating
FROM reviews
GROUP BY month, product_id;

-- SQLite (using strftime)
SELECT strftime('%m', submit_date) AS month, product_id, ROUND(AVG(stars), 2) AS avg_rating
FROM reviews
GROUP BY month, product_id;
```

#### 2. Cohort Purchase Differences (Within 30 Days)
```sql
-- PostgreSQL
WITH ranked_orders AS (
    SELECT user_id, order_date,
           DENSE_RANK() OVER(PARTITION BY user_id ORDER BY order_date) AS rnk,
           LAG(order_date) OVER(PARTITION BY user_id ORDER BY order_date) AS prev_order
    FROM orders
)
SELECT * FROM ranked_orders
WHERE rnk = 2 AND order_date - prev_order <= 30;

-- MySQL
WITH ranked_orders AS (
    SELECT user_id, order_date,
           DENSE_RANK() OVER(PARTITION BY user_id ORDER BY order_date) AS rnk,
           LAG(order_date) OVER(PARTITION BY user_id ORDER BY order_date) AS prev_order
    FROM orders
)
SELECT * FROM ranked_orders
WHERE rnk = 2 AND DATEDIFF(order_date, prev_order) <= 30;

-- SQLite
WITH ranked_orders AS (
    SELECT user_id, order_date,
           DENSE_RANK() OVER(PARTITION BY user_id ORDER BY order_date) AS rnk,
           LAG(order_date) OVER(PARTITION BY user_id ORDER BY order_date) AS prev_order
    FROM orders
)
SELECT * FROM ranked_orders
WHERE rnk = 2 AND julianday(order_date) - julianday(prev_order) <= 30;
```
</details>

---

## 3. Aggregate & Conditional Functions

| Function | Key Concept / Purpose | Key Rule |
| :--- | :--- | :--- |
| **`SUM / COUNT / AVG / MIN / MAX`** | Basic aggregations | Must pair with `GROUP BY` for non-aggregated columns |
| **`COUNT(DISTINCT col)`** | Count unique values | Ignores duplicates |
| **`HAVING`** | Filter on aggregated results | Evaluated **after** `GROUP BY` (`WHERE` is evaluated before) |
| **`CASE WHEN`** | Conditional branching (if/elif/else) | Evaluated in order, returns first match |

<details>
<summary><b>View Aggregate & Conditional Examples</b></summary>

```sql
-- 1. Pivot device types into columns (Facebook - 06.sql)
SELECT
    SUM(CASE WHEN device_type = 'laptop' THEN viewership_count ELSE 0 END) AS laptop_views,
    SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN viewership_count ELSE 0 END) AS mobile_views
FROM viewership;

-- 2. Companies with duplicate job listings (LinkedIn - 14.sql)
SELECT company_id, title, COUNT(1) AS total_job
FROM job_listings
GROUP BY 1, 2
HAVING COUNT(1) > 1;
```
</details>

---

## 4. NULL Handling & Math Functions

| Function / Technique | Syntax / Pattern | Purpose |
| :--- | :--- | :--- |
| **`COALESCE()`** | `COALESCE(possibly_null, fallback)` | Returns first non-NULL value in list |
| **`IS NULL / IS NOT NULL`** | `col IS NULL` | Check if a column has missing (NULL) values |
| **`ROUND()`** | `ROUND(value, decimal_places)` | Formats numeric outputs |
| **`ABS()`** | `ABS(value)` | Absolute value (great for differences/variances) |
| **Float Cast** | `col * 1.0` or `col::float` | Avoids integer division truncation |

<details>
<summary><b>View NULL & Math Examples</b></summary>

```sql
-- 1. Default NULL end_date to today for duration check (IBM - 12.sql)
SELECT department,
       AVG(end_date - COALESCE(start_date, CURRENT_DATE)) AS avg_duration
FROM employee_service
GROUP BY 1;

-- 2. Avoid integer division truncation (Amazon - 26.sql)
SELECT ROUND((returned_items * 1.0 / total_items_ordered) * 100, 2) AS return_pct
FROM order_summary;
```
</details>

---

## 5. String & Formatting Functions

| Function | Purpose | Example | Result |
| :--- | :--- | :--- | :--- |
| **`UPPER(col)` / `LOWER(col)`** | Standardize case | `UPPER('sql')` | `'SQL'` |
| **`TRIM(col)`** | Remove leading/trailing spaces | `TRIM('  hi  ')` | `'hi'` |
| **`LENGTH(col)`** | Count characters | `LENGTH('SQL')` | `3` |
| **`SUBSTRING(col, start, len)`** | Extract slice | `SUBSTRING('hello', 1, 3)` | `'hel'` |
| **`CONCAT(a, b)`** | Join strings | `CONCAT('first', ' ', 'last')`| `'first last'` |
| **`LIKE` / `ILIKE`** | Pattern match (`%` wildcard) | `WHERE col ILIKE 'A%'` | Case-insensitive starts with A |

---

## 6. CTEs & Subquery Patterns

### Common Table Expression (CTE) Template
```sql
WITH first_step AS (
    SELECT user_id, COUNT(order_id) AS orders_count FROM orders GROUP BY 1
),
second_step AS (
    SELECT user_id, orders_count, DENSE_RANK() OVER(ORDER BY orders_count DESC) AS rnk FROM first_step
)
SELECT * FROM second_step WHERE rnk = 1;
```

### Essential Subquery Patterns
- **Anti-Join:** `WHERE col NOT IN (SELECT DISTINCT col FROM table)` 
- **Derived Table:** `SELECT * FROM (SELECT ... ) x1` 
- **Scalar Lookup:** `WHERE spend = (SELECT MAX(spend) FROM table)`

<details>
<summary><b>View CTE & Subquery Examples</b></summary>

```sql
-- Amazon - 07.sql: Top 2 products per category using chained CTEs
WITH total_trans AS (
    SELECT category, product, SUM(spend) AS total_spend
    FROM product_spend
    WHERE EXTRACT(YEAR FROM transaction_date) = 2022
    GROUP BY 1, 2
),
high_sell_prod AS (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_spend DESC) AS rw_nm
    FROM total_trans
)
SELECT category, product, total_spend
FROM high_sell_prod
WHERE rw_nm <= 2;
```
</details>

---

## 7. Join Patterns

- **Anti-Join (`LEFT JOIN ... WHERE B.col IS NULL`):** Find non-matching records (e.g. users who never purchased).
- **Self-Join (`JOIN` a table to itself):** Query hierarchies (manager/employee) or compare sequential rows.
- **Cross-Join (`CROSS JOIN`):** Cartesian product (all combinations) for matrix generation.

<details>
<summary><b>View Join Examples</b></summary>

```sql
-- 1. Anti-Join via NOT IN: Pages with zero likes (Facebook)
-- File: 30_Days_SQL_Challenge/02.sql
SELECT p.page_id
FROM pages p
WHERE p.page_id NOT IN (SELECT DISTINCT page_id FROM page_likes);

-- 2. Anti-Join via LEFT JOIN: Pages with zero likes (Facebook)
-- File: 30_Days_SQL_Challenge/02.sql
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes pl ON p.page_id = pl.page_id
WHERE pl.page_id IS NULL;

-- 3. Self-Join via LEFT JOIN: Manager-Employee hierarchy (TCS)
-- File: 30_Days_SQL_Challenge/22.sql
SELECT e1.emp_id, e1.emp_name, e2.emp_name AS manager_name
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.emp_id;

-- 4. CROSS JOIN: Manager-Employee lookup (TCS)
-- File: 30_Days_SQL_Challenge/22.sql
-- CROSS JOIN produces a Cartesian product. When filtered with WHERE, it acts like an INNER JOIN.
-- Useful when you want every combination and then narrow down with a condition.
SELECT e1.emp_id, e1.emp_name, e1.manager_id, e2.emp_name AS manager_name
FROM employees AS e1
CROSS JOIN employees AS e2
WHERE e1.manager_id = e2.emp_id;

-- 5. Running Total Self-Join (alternative to window function) (Flipkart)
-- File: 30_Days_SQL_Challenge/25.sql
SELECT o1.date, o1.product_id, o1.product_name, o1.revenue,
       SUM(o2.revenue) AS running_total
FROM orders AS o1
JOIN orders AS o2
    ON o1.product_id = o2.product_id AND o1.date >= o2.date
GROUP BY o1.date, o1.product_id, o1.product_name, o1.revenue
ORDER BY 1, 2;
```
</details>

---

## 8. Median — Classic Interview Pattern

```sql
WITH ranked_cte AS (
    SELECT views,
           ROW_NUMBER() OVER(ORDER BY views ASC)  AS rn_asc,
           ROW_NUMBER() OVER(ORDER BY views DESC) AS rn_desc
    FROM tiktok
)
SELECT AVG(views) AS median
FROM ranked_cte
WHERE ABS(rn_asc - rn_desc) <= 1;
```
**File:** `30_Days_SQL_Challenge/16.sql` — TikTok Interview Question

---

## 9. LIMIT / TOP / FETCH FIRST — Restricting Result Rows

| Dialect | Syntax | Notes |
| :--- | :--- | :--- |
| **MySQL** | `SELECT ... LIMIT n;` | Most common shorthand |
| **MySQL (offset)** | `SELECT ... LIMIT offset, n;` | Skip `offset` rows, return `n` |
| **PostgreSQL** | `SELECT ... LIMIT n;` | Same as MySQL |
| **PostgreSQL (standard)** | `SELECT ... FETCH FIRST n ROWS ONLY;` | SQL standard syntax |
| **SQLite** | `SELECT ... LIMIT n;` | Same as MySQL |
| **SQL Server** | `SELECT TOP n ...;` | Goes **before** column list, not at end |
| **Oracle** | `WHERE ROWNUM <= n` | Filter-based, must wrap sorted subquery |

<details>
<summary><b>View LIMIT / TOP Examples</b></summary>

```sql
-- 1. MySQL / PostgreSQL / SQLite — Top 5 products by revenue decrease (Amazon) File: 30_Days_SQL_Challenge/05.sql
SELECT product_name, revenue_decreased, rev_decreased_ratio
FROM rev_comp
WHERE revenue_decreased > 0
LIMIT 5;

-- 2. PostgreSQL — Top 5 customers by return percentage (Amazon) File: 30_Days_SQL_Challenge/26.sql
SELECT customer_id, return_percentage
FROM result_cte
ORDER BY return_percentage DESC
LIMIT 5;

-- 3. MySQL / PostgreSQL / SQLite — Top 5 songs by listen count (Spotify) File: 30_Days_SQL_Challenge/30.sql
SELECT song_name, times_of_listens
FROM (
    SELECT s.song_name, COUNT(l.listen_id) AS times_of_listens
    FROM Songs s
    JOIN Listens l ON s.song_id = l.song_id
    GROUP BY s.song_name
) AS sub
ORDER BY times_of_listens DESC
LIMIT 5;

-- 4. PostgreSQL — FETCH FIRST (SQL standard equivalent of LIMIT) File: 30_Days_SQL_Challenge/28.sql
SELECT seller_id, total_sales, total_return_qty
FROM result_cte
ORDER BY total_sales DESC, total_return_qty ASC
FETCH FIRST 3 ROWS ONLY;

-- 5. SQL Server equivalent (TOP goes at the start)
SELECT TOP 5 song_name, times_of_listens
FROM sub
ORDER BY times_of_listens DESC;
```
</details>

---

## 10. CAST & Type Casting

### Dialect Comparison
| Dialect | Syntax | Use Case |
| :--- | :--- | :--- |
| **Standard SQL** | `CAST(col AS type)` | Universal — works in all dialects |
| **PostgreSQL shorthand** | `col::type` | Cleaner syntax, PostgreSQL-only |
| **MySQL** | `CAST(col AS DECIMAL)` or `col * 1.0` | No `::` shorthand |
| **SQLite** | `CAST(col AS REAL)` or `col * 1.0` | No `::` shorthand |

### Common Target Types
| Type | Purpose |
| :--- | :--- |
| `FLOAT` / `REAL` | Force decimal division (avoid integer truncation) |
| `NUMERIC(p, s)` | Precise decimal with precision and scale |
| `VARCHAR` / `TEXT` | Convert number/date to string |
| `DATE` | Convert string literal to a date |
| `INTEGER` | Truncate float to whole number |

<details>
<summary><b>View CAST / Type Casting Examples</b></summary>

```sql
-- 1. PostgreSQL :: shorthand — Cast string literal to DATE for date arithmetic (Flipkart) File: 30_Days_SQL_Challenge/15.sql
WHERE EXTRACT(MONTH FROM saledate) = EXTRACT(MONTH FROM '2024-03-01'::DATE) - 1

-- 2. PostgreSQL :: shorthand — Cast to FLOAT to avoid integer division (Amazon) File: 30_Days_SQL_Challenge/26.sql
ROUND(
    CASE
        WHEN total_items_ordered > 0
        THEN (total_items_returned::FLOAT / total_items_ordered::FLOAT) * 100
        ELSE 0
    END::NUMERIC, 2
) AS return_percentage

-- 3. Multiply by 1.0 — Universal float cast trick (Amazon) File: 30_Days_SQL_Challenge/26.sql
ROUND((returned_items * 1.0 / total_items_ordered) * 100, 2) AS return_pct

-- 4. Standard CAST() — Convert string to integer for year extraction (SQLite) File: General SQLite pattern for strftime results
SELECT CAST(strftime('%Y', '2026-05-22') AS INTEGER) AS year_int;

-- 5. CAST to NUMERIC for rounding — PostgreSQL File: 30_Days_SQL_Challenge/26.sql
ROUND((some_float_result)::NUMERIC, 2)

-- Dialect Quick Reference:
-- MySQL/SQLite: col * 1.0   OR   CAST(col AS DECIMAL(10,2))
-- PostgreSQL:   col::float  OR   CAST(col AS FLOAT)
-- SQL Server:   CAST(col AS FLOAT)  OR  CONVERT(FLOAT, col)
```
</details>
