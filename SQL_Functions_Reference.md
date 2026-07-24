# SQL Functions Reference Guide

## 1. Window Functions

### Ranking Functions
| Function | Syntax | Ties Handling |
| :--- | :--- | :--- |
| **`ROW_NUMBER()`** | `ROW_NUMBER() OVER(...)` | 1,2,3,4,5,6.. |
| **`RANK()`** | `RANK() OVER(...)` | 1,1,3,4,5... |
| **`DENSE_RANK()`** | `DENSE_RANK() OVER(...)` | 1,1,2,3,4... |

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
| **`COUNT(*) OVER()`** | `COUNT(*) OVER(PARTITION BY col)` | Windowed count without collapsing rows (great for tagging/flagging) |

<details>
<summary><b>View Value/Analytics Examples</b></summary>

```sql
-- 1. LAG: Compare product revenue to previous year (Amazon) File: 30_Days_SQL_Challenge/05.sql
WITH prev_rev AS (
    SELECT *,
        LAG(revenue) OVER(PARTITION BY product_name ORDER BY year) AS prev_year_revenue
    FROM product_revenue
)
SELECT product_name, 
    revenue AS current_year_revenue, 
    prev_year_revenue,
    ROUND(((prev_year_revenue - revenue) / prev_year_revenue) * 100.0, 2) AS pct_decrease
FROM prev_rev
WHERE prev_year_revenue > revenue;

-- 2. Moving Average: 3-day rolling average (General pattern)
SELECT order_date, amount,
       AVG(amount) OVER(PARTITION BY user_id ORDER BY order_date
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

-- 4. LEAD: Success rate after a failed post (Exponent) File: Exponent/16__Post Success After Failure.md
WITH post_succ_cte AS (
    SELECT user_id, post_date,
        is_successful_post AS prev_post_is_succ,
        LEAD(is_successful_post) OVER (PARTITION BY user_id ORDER BY post_date) AS next_post_is_succ
    FROM post
)
SELECT user_id,
    SUM(CASE WHEN prev_post_is_succ = 0 AND next_post_is_succ = 1 THEN 1 ELSE 0 END)
        * 100.00 / COUNT(*) AS next_post_sc_rate
FROM post_succ_cte
GROUP BY 1;

-- 5. COUNT(*) OVER(): Tag each transaction with total offences per customer (Visa - Exponent) File: Exponent/12_Fraudulent Transactions.md
WITH SuspiciousTransactions AS (
    SELECT customer_id, receipt_number,
        COUNT(*) OVER (PARTITION BY customer_id) AS no_of_offences
    FROM transactions
    WHERE receipt_number LIKE '%999%'
       OR receipt_number LIKE '%1234%'
       OR receipt_number LIKE '%XYZ%'
)
SELECT c.first_name, c.last_name, s.receipt_number, s.no_of_offences
FROM customers c
JOIN SuspiciousTransactions s ON c.customer_id = s.customer_id
WHERE s.no_of_offences >= 2;
```
</details>

---

## 2. Date & Time Functions

| Scenario | MySQL | PostgreSQL | SQLite |
| :--- | :--- | :--- | :--- |
| **1. Extract Part from Date** | `EXTRACT(MONTH FROM date)`<br>`YEAR(date)`, `MONTH(date)`, `DAY(date)` | `EXTRACT(MONTH FROM DATE '...')`<br>`date_part('year', TIMESTAMP '...')` | `strftime('%m', date)`<br>CAST(strftime('%Y', date) AS INTEGER) |
| **2. Format Part of Date** | `DATE_FORMAT(date, '%Y-%m')` | `TO_CHAR(TIMESTAMP '...', 'YYYY-MM')` | strftime('%Y-%m', date) |
| **3. Get Current Date** | `CURRENT_DATE()` / `CURDATE()`<br>`NOW()` / `CURRENT_TIMESTAMP()` | `CURRENT_DATE`<br>`NOW()` / `CURRENT_TIMESTAMP` | date('now') / CURRENT_DATE<br>datetime('now') / CURRENT_TIMESTAMP |
| **4. Date Differences** | `DATEDIFF(date1, date2)` *(days)*<br>`TIMESTAMPDIFF(MONTH, d1, d2)` | `date1 - date2` *(integer days)*<br>`AGE(ts1, ts2)` *(interval)* | julianday(d1) - julianday(d2) |
| **5. Date Arithmetic** | `date + INTERVAL 7 DAY` <br> `date + INTERVAL 1 MONTH`<br>`date + INTERVAL 1 YEAR` | `date + INTERVAL '7 days'`<br>`date + INTERVAL '1 month'`<br>`date + INTERVAL '1 year'` | date(date, '+7 days') |
| **6. Rolling Window (Range)** | `RANGE BETWEEN INTERVAL 2 DAY PRECEDING AND CURRENT ROW` | `RANGE BETWEEN INTERVAL '2 days' PRECEDING AND CURRENT ROW` | RANGE BETWEEN 172800 PRECEDING AND CURRENT ROW |
| **7. DATE_TRUNC (Truncate to Month/Year)** | *Not native* — `DATE_FORMAT(date, '%Y-%m-01')` | `DATE_TRUNC('month', date)`<br>`DATE_TRUNC('year', date)` | date(date, 'start of month')<br>date(date, 'start of year') |
| **8. TimeStamp Difference in Seconds** | `TIMESTAMPDIFF(SECOND, ts1, ts2)` | `EXTRACT(EPOCH FROM (ts2 - ts1))` | strftime('%s', ts2) - strftime('%s', ts1) |
| **9. Past N Days (Integer Arithmetic)** | `CURRENT_DATE - INTERVAL 7 DAY`<br>`CURDATE() - INTERVAL 7 DAY` | `CURRENT_DATE - 7` | date('now', '-7 days') |

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
-- MySQL
WITH ranked_orders AS (
    SELECT user_id, order_date,
           DENSE_RANK() OVER(PARTITION BY user_id ORDER BY order_date) AS rnk,
           LAG(order_date) OVER(PARTITION BY user_id ORDER BY order_date) AS prev_order
    FROM orders
)
SELECT * FROM ranked_orders
WHERE rnk = 2 AND DATEDIFF(order_date, prev_order) <= 30;

-- PostgreSQL
WITH ranked_orders AS (
    SELECT user_id, order_date,
           DENSE_RANK() OVER(PARTITION BY user_id ORDER BY order_date) AS rnk,
           LAG(order_date) OVER(PARTITION BY user_id ORDER BY order_date) AS prev_order
    FROM orders
)
SELECT * FROM ranked_orders
WHERE rnk = 2 AND order_date - prev_order <= 30;

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

#### 3. Past N Days Filtering (CURRENT_DATE - N)
```sql
-- PostgreSQL: Filter posts from the last 7 days (Facebook) File: 30_Days_SQL_Challenge/13.sql
SELECT user_id, SUM(likes) AS total_likes, COUNT(post_id) AS cnt_post
FROM posts
WHERE post_date >= CURRENT_DATE - 7
  AND post_date < CURRENT_DATE
GROUP BY user_id
HAVING COUNT(post_id) > 2;
-- NOTE: In PostgreSQL, CURRENT_DATE is a DATE type and subtracting an integer gives (date - N days).
-- In MySQL, use: WHERE post_date >= CURDATE() - INTERVAL 7 DAY
-- In SQLite, use: WHERE post_date >= date('now', '-7 days')
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
| **`FLOOR()`** | `FLOOR(value / bin_size)` | Rounds down to nearest integer — great for histogram binning |
| **Float Cast** | `col * 1.0` or `col::float` | Avoids integer division truncation |
| **`<>` / `!=`** | `col1 <> col2` | Not-equal comparison — standard SQL uses `<>`; `!=` also works in most dialects |
| **`<` `>` `<=` `>=`** | `timestamp1 < timestamp2` | Comparison operators — work on numbers, dates, timestamps, and strings |

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

<details>
<summary><b>View String Function Examples</b></summary>

```sql
-- 1. LOWER + TRIM: Deduplicate emails by normalizing case/whitespace (Exponent) File: Exponent/04_Remove Duplicates Emails.md
SELECT id, LOWER(TRIM(email)) AS email
FROM users
WHERE id IN (
    SELECT MIN(id)
    FROM users
    GROUP BY LOWER(TRIM(email))
)
ORDER BY id;

-- 2. LIKE with OR: Flag suspicious receipt numbers containing patterns (Visa - Exponent) File: Exponent/12_Fraudulent Transactions.md
SELECT * FROM transactions
WHERE receipt_number LIKE '%999%'
   OR receipt_number LIKE '%1234%'
   OR receipt_number LIKE '%XYZ%';

-- 3. FLOOR: Create histogram bins of 5-minute (300-second) intervals (Amazon - Exponent) File: Exponent/10_Session_DA_Amazon.md
SELECT
    FLOOR(session_time / 300) AS session_bin,
    COUNT(*) AS session_count
FROM sessions
GROUP BY 1
ORDER BY 1;
```
</details>

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
- **LEFT JOIN Filtering Gotcha:** Filters on the right table must go in the `ON` clause, NOT the `WHERE` clause. A filter in the `WHERE` clause filters out the NULL values produced by non-matching rows, effectively converting the `LEFT JOIN` to an `INNER JOIN`.

<details>
<summary><b>View Join Examples</b></summary>

```sql
-- 1. Anti-Join via NOT IN: Pages with zero likes (Facebook) File: 30_Days_SQL_Challenge/02.sql
SELECT p.page_id
FROM pages p
WHERE p.page_id NOT IN (SELECT DISTINCT page_id FROM page_likes);

-- 2. Anti-Join via LEFT JOIN: Pages with zero likes (Facebook) File: 30_Days_SQL_Challenge/02.sql
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes pl ON p.page_id = pl.page_id
WHERE pl.page_id IS NULL;

-- 3. Self-Join via LEFT JOIN: Manager-Employee hierarchy (TCS) File: 30_Days_SQL_Challenge/22.sql
SELECT e1.emp_id, e1.emp_name, e2.emp_name AS manager_name
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.emp_id;

-- 4. CROSS JOIN: Manager-Employee lookup (TCS) File: 30_Days_SQL_Challenge/22.sql
-- CROSS JOIN produces a Cartesian product. When filtered with WHERE, it acts like an INNER JOIN.
-- Useful when you want every combination and then narrow down with a condition.
SELECT e1.emp_id, e1.emp_name, e1.manager_id, e2.emp_name AS manager_name
FROM employees AS e1
CROSS JOIN employees AS e2
WHERE e1.manager_id = e2.emp_id;

-- 5. Running Total Self-Join (alternative to window function) (Flipkart) File: 30_Days_SQL_Challenge/25.sql
SELECT o1.date, o1.product_id, o1.product_name, o1.revenue,
       SUM(o2.revenue) AS running_total
FROM orders AS o1
JOIN orders AS o2
    ON o1.product_id = o2.product_id AND o1.date >= o2.date
GROUP BY o1.date, o1.product_id, o1.product_name, o1.revenue
ORDER BY 1, 2;

-- 6. LEFT JOIN Filtering Gotcha: Keep categories with 0 units ordered in the last 7 days (Amazon) File: Real Interview Questions/Amazon SQL Coding Question/Readme.md
SELECT
    i.item_category,
    COALESCE(SUM(o.order_quantity), 0) AS total_units_ordered
FROM items i
LEFT JOIN orders o ON i.item_id = o.item_id 
    AND CAST(o.order_datetime AS DATE) BETWEEN CURRENT_DATE - 6 AND CURRENT_DATE
GROUP BY i.item_category;
-- NOTE: Placing "CAST(o.order_datetime AS DATE) BETWEEN..." in the WHERE clause would filter out items with NULL order quantities, thus omitting categories with zero orders from the final result.
```
</details>

---

## 8. Median — Classic Interview Pattern
**File:** `30_Days_SQL_Challenge/16.sql` — TikTok Interview Question

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

```sql
-- Method 2: Partitioned / Grouped Median (Using COUNT and FLOOR/CEIL)
-- File: `Real Interview Questions/04_Amazon_SQL_DA_Questions.md` — Question 5 (Amazon)
-- Best approach when calculating medians grouped by a category (e.g. department_id)
WITH cte AS (
    SELECT department_id, salary,
           ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary ASC) AS row_nm,
           COUNT(*) OVER(PARTITION BY department_id) AS cnt
    FROM employees
)
SELECT department_id,
       AVG(salary) AS median_salary
FROM cte
WHERE row_nm IN (FLOOR((cnt + 1) / 2.0), CEIL((cnt + 1) / 2.0))
GROUP BY department_id;
-- Note: Dividing by 2.0 ensures floating-point division in databases that default to integer division.
```


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
-- 1. MySQL / PostgreSQL / SQLite — Top 5 songs by listen count (Spotify) File: 30_Days_SQL_Challenge/30.sql
SELECT song_name, times_of_listens
FROM (
    SELECT s.song_name, COUNT(l.listen_id) AS times_of_listens
    FROM Songs s
    JOIN Listens l ON s.song_id = l.song_id
    GROUP BY s.song_name
) AS sub
ORDER BY times_of_listens DESC
LIMIT 5;

-- 2. PostgreSQL — FETCH FIRST (SQL standard equivalent of LIMIT) File: 30_Days_SQL_Challenge/28.sql
SELECT seller_id, total_sales, total_return_qty
FROM result_cte
ORDER BY total_sales DESC, total_return_qty ASC
FETCH FIRST 3 ROWS ONLY;

-- 3. SQL Server equivalent (TOP goes at the start)
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

---

## 11. Advanced Window Functions

| Function | Syntax | Purpose |
| :--- | :--- | :--- |
| **`NTILE(n)`** | `NTILE(4) OVER(ORDER BY salary DESC)` | Splits rows into **n** equal buckets (great for quartiles/percentiles) |
| **`PERCENT_RANK()`** | `PERCENT_RANK() OVER(ORDER BY score)` | Relative rank as a fraction `(rank-1)/(total_rows-1)` — range `[0,1]` |
| **`CUME_DIST()`** | `CUME_DIST() OVER(ORDER BY score)` | Cumulative distribution — fraction of rows ≤ current row |
| **`FIRST_VALUE(col)`** | `FIRST_VALUE(col) OVER(PARTITION BY ... ORDER BY ...)` | Returns first value in the window frame |
| **`LAST_VALUE(col)`** | `LAST_VALUE(col) OVER(... ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)` | Returns last value in the window frame |
| **`NTH_VALUE(col, n)`** | `NTH_VALUE(col, 2) OVER(...)` | Returns the nth value in the window |

<details>
<summary><b>View Advanced Window Function Examples</b></summary>

```sql
-- 1. NTILE: Label employees by salary quartile
SELECT emp_name, salary,
       NTILE(4) OVER(ORDER BY salary DESC) AS salary_quartile
FROM employees;
-- Quartile 1 = top 25%, Quartile 4 = bottom 25%

-- 2. PERCENT_RANK: What % of products have lower sales than this one?
SELECT product_id, total_sales,
       ROUND(PERCENT_RANK() OVER(ORDER BY total_sales) * 100, 2) AS pct_rank
FROM product_summary;

-- 3. CUME_DIST: Find top 30% of customers by spend
SELECT customer_id, total_spend
FROM (
    SELECT customer_id, total_spend,
           CUME_DIST() OVER(ORDER BY total_spend DESC) AS cum_dist
    FROM customer_summary
) x
WHERE cum_dist <= 0.30;

-- 4. FIRST_VALUE / LAST_VALUE: Compare each row to the department's highest/lowest salary
SELECT emp_name, department, salary,
       FIRST_VALUE(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS dept_max_salary,
       LAST_VALUE(salary)  OVER(PARTITION BY department ORDER BY salary DESC
                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS dept_min_salary
FROM employees;
-- NOTE: LAST_VALUE needs explicit frame to include all rows (default frame stops at current row)

-- 5. NTH_VALUE: Get the 2nd highest salary per department
SELECT emp_name, department, salary,
       NTH_VALUE(salary, 2) OVER(PARTITION BY department ORDER BY salary DESC
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS second_highest
FROM employees;
```
</details>

---

## 12. NULL Safety & Conditional Functions

| Function | Syntax | Purpose | Note |
| :--- | :--- | :--- | :--- |
| **`NULLIF(a, b)`** | `NULLIF(denominator, 0)` | Returns NULL if `a = b`, else returns `a` | **Critical to prevent division-by-zero errors** |
| **`IFNULL(col, default)`** | `IFNULL(score, 0)` | Returns `default` if `col` IS NULL | MySQL / SQLite only |
| **`ISNULL(col, default)`** | `ISNULL(score, 0)` | Same as `IFNULL` | SQL Server only |
| **`NVL(col, default)`** | `NVL(score, 0)` | Same as `IFNULL` | Oracle only |
| **`COALESCE(a, b, c, ...)`** | `COALESCE(col1, col2, 0)` | Returns first non-NULL from the list | **Universally supported — preferred** |
| **`IIF(cond, true_val, false_val)`** | `IIF(score > 90, 'A', 'B')` | Inline if/else shorthand | SQL Server / Access only |

<details>
<summary><b>View NULL Safety & Conditional Examples</b></summary>

```sql
-- 1. NULLIF: Avoid division by zero (universal pattern)
SELECT product_id,
       total_revenue / NULLIF(total_units_sold, 0) AS avg_revenue_per_unit
FROM product_summary;
-- If total_units_sold = 0, the denominator becomes NULL → result is NULL (safe, no error)

-- 2. COALESCE vs IFNULL (behavior is identical for 2 arguments):
SELECT emp_name,
       COALESCE(bonus, 0)   AS bonus_coalesce,   -- Works in ALL dialects
       IFNULL(bonus, 0)     AS bonus_ifnull       -- MySQL / SQLite only
FROM employees;

-- 3. COALESCE with multiple fallbacks (COALESCE wins here — IFNULL only takes 2 args):
SELECT COALESCE(preferred_email, work_email, personal_email, 'no-email@unknown.com') AS contact_email
FROM users;

-- 4. Combined pattern: NULLIF + ROUND + COALESCE (production-grade safe division)
SELECT
    ROUND(COALESCE(num_clicks * 1.0 / NULLIF(num_impressions, 0), 0) * 100, 2) AS ctr_pct
FROM ad_metrics;
```
</details>

---

## 13. Advanced String Functions

| Function | MySQL | PostgreSQL | SQL Server | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **`LEFT(col, n)`** | `LEFT(col, 3)` | `LEFT(col, 3)` | `LEFT(col, 3)` | First `n` characters |
| **`RIGHT(col, n)`** | `RIGHT(col, 3)` | `RIGHT(col, 3)` | `RIGHT(col, 3)` | Last `n` characters |
| **`REPLACE(col, old, new)`** | `REPLACE(col,'a','b')` | `REPLACE(col,'a','b')` | `REPLACE(col,'a','b')` | Substitute substring |
| **`POSITION(sub IN col)`** | `POSITION('x' IN col)` | `POSITION('x' IN col)` | `CHARINDEX('x', col)` | Index of first occurrence |
| **`SPLIT_PART(col, delim, n)`** | `SUBSTRING_INDEX(col,',',1)` | `SPLIT_PART(col,',',1)` | *(use STRING_SPLIT)* | Extract nth split token |
| **`REGEXP_LIKE(col, pattern)`** | `col REGEXP 'pattern'` | `col ~ 'pattern'` | `col LIKE '%pattern%'`* | Regex pattern match |
| **`LPAD / RPAD`** | `LPAD(col, 5, '0')` | `LPAD(col, 5, '0')` | `RIGHT('00000'+col, 5)` | Pad string to fixed width |
| **`REVERSE(col)`** | `REVERSE(col)` | `REVERSE(col)` | `REVERSE(col)` | Reverse a string |

<details>
<summary><b>View Advanced String Function Examples</b></summary>

```sql
-- 1. LEFT / RIGHT: Extract area code and last 4 digits from phone number
SELECT phone_number,
       LEFT(phone_number, 3)  AS area_code,
       RIGHT(phone_number, 4) AS last_four
FROM customers;

-- 2. REPLACE: Sanitize data by removing unwanted characters
SELECT REPLACE(REPLACE(phone_number, '-', ''), ' ', '') AS clean_phone
FROM customers;

-- 3. POSITION (PostgreSQL/MySQL) vs CHARINDEX (SQL Server):
-- Find the position of '@' in an email to extract the domain
-- PostgreSQL / MySQL:
SELECT email, SUBSTRING(email, POSITION('@' IN email) + 1) AS domain FROM users;
-- SQL Server:
SELECT email, SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS domain FROM users;

-- 4. SPLIT_PART: Extract first name from a full name (PostgreSQL)
SELECT SPLIT_PART(full_name, ' ', 1) AS first_name FROM employees;

-- MySQL equivalent using SUBSTRING_INDEX:
SELECT SUBSTRING_INDEX(full_name, ' ', 1) AS first_name FROM employees;

-- 5. REGEXP: Find rows where email doesn't match a valid pattern (MySQL)
SELECT * FROM users WHERE email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

-- PostgreSQL equivalent using ~ (tilde):
SELECT * FROM users WHERE email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

-- 6. LPAD: Zero-pad an ID to always be 6 digits wide
SELECT LPAD(CAST(user_id AS VARCHAR), 6, '0') AS padded_id FROM users;
```
</details>

---

## 14. GROUP BY Extensions (ROLLUP, CUBE, GROUPING SETS)

| Clause | Purpose | Typical Use Case |
| :--- | :--- | :--- |
| **`GROUP BY ROLLUP(a, b)`** | Hierarchical subtotals: `(a,b)`, `(a)`, `()` | Sales totals by region → country → grand total |
| **`GROUP BY CUBE(a, b)`** | All possible subtotal combinations | Cross-dimensional reporting (every combo of dims) |
| **`GROUP BY GROUPING SETS((a,b),(a),(b),())`** | Explicit control over which groupings to include | Custom multi-level aggregation |
| **`GROUPING(col)`** | Returns 1 if the column is aggregated (NULL represents subtotal), 0 otherwise | Distinguish real NULLs from rollup NULLs |

<details>
<summary><b>View GROUP BY Extension Examples</b></summary>

```sql
-- 1. ROLLUP: Sales by (region, product), then just (region), then grand total
SELECT region, product, SUM(sales) AS total_sales
FROM orders
GROUP BY ROLLUP(region, product)
ORDER BY region, product;
-- Produces rows for each (region, product) pair + a subtotal per region + a grand total row

-- 2. CUBE: Every combination of (region) and (year)
SELECT region, year, SUM(revenue) AS total_revenue
FROM sales
GROUP BY CUBE(region, year);
-- Produces: (region,year), (region), (year), () — all 4 combinations

-- 3. GROUPING SETS: Explicitly pick only the groupings you need
SELECT region, product_category, SUM(revenue) AS total_revenue
FROM sales
GROUP BY GROUPING SETS (
    (region, product_category),   -- by both dimensions
    (region),                      -- by region only
    ()                             -- grand total only
);

-- 4. GROUPING(): Differentiate real NULLs from subtotal NULLs
SELECT
    CASE WHEN GROUPING(region) = 1 THEN 'ALL REGIONS' ELSE region END AS region_label,
    SUM(sales) AS total_sales
FROM orders
GROUP BY ROLLUP(region);
```
</details>

---

## 15. Set Operations (UNION, INTERSECT, EXCEPT)

| Operator | Behavior | Duplicates |
| :--- | :--- | :--- |
| **`UNION`** | Combines results of two queries | **Removes** duplicates (like `DISTINCT`) |
| **`UNION ALL`** | Combines results of two queries | **Keeps** all rows including duplicates — faster than `UNION` |
| **`INTERSECT`** | Returns rows present in **both** queries | Removes duplicates |
| **`EXCEPT`** (`MINUS` in Oracle) | Returns rows in first query **not** in second | Removes duplicates |

> **Key Rules:**
> - Both queries must have the **same number of columns** and **compatible data types**
> - Column names come from the **first** query
> - `ORDER BY` goes at the very end (applies to the full combined result)

<details>
<summary><b>View Set Operation Examples</b></summary>

```sql
-- 1. UNION: Combine customers from two regions (deduplicating overlaps)
SELECT customer_id, name FROM customers_us
UNION
SELECT customer_id, name FROM customers_eu;

-- 2. UNION ALL: Combine all transactions from two tables (keep duplicates, faster)
SELECT order_id, amount, 'online' AS channel FROM online_orders
UNION ALL
SELECT order_id, amount, 'in_store' AS channel FROM store_orders;

-- 3. INTERSECT: Find customers who bought in BOTH last month AND this month
SELECT customer_id FROM orders WHERE EXTRACT(MONTH FROM order_date) = 5
INTERSECT
SELECT customer_id FROM orders WHERE EXTRACT(MONTH FROM order_date) = 6;

-- 4. EXCEPT: Find customers who bought last month but NOT this month (churned)
SELECT customer_id FROM orders WHERE EXTRACT(MONTH FROM order_date) = 5
EXCEPT
SELECT customer_id FROM orders WHERE EXTRACT(MONTH FROM order_date) = 6;

-- Oracle equivalent uses MINUS instead of EXCEPT:
-- SELECT customer_id FROM last_month_orders
-- MINUS
-- SELECT customer_id FROM this_month_orders;

-- 5. Classic interview pattern: Symmetric difference using UNION ALL + EXCEPT
-- (rows in A not in B, OR rows in B not in A)
(SELECT customer_id FROM table_a EXCEPT SELECT customer_id FROM table_b)
UNION ALL
(SELECT customer_id FROM table_b EXCEPT SELECT customer_id FROM table_a);

-- 6. UNION to normalize bidirectional pairs: Count unique conversations (WhatsApp - Exponent) File: Exponent/20__Unique Chat Conversations.md
-- Trick: UNION both directions, then filter user1 < user2 to keep each pair only once
WITH messages AS (
    SELECT sender_id AS user1, receiver_id AS user2 FROM messenger_sends
    UNION
    SELECT receiver_id AS user1, sender_id AS user2 FROM messenger_sends
)
SELECT COUNT(*) AS unique_conversations
FROM messages
WHERE user1 < user2;
```
</details>

---

## 16. EXISTS & NOT EXISTS

| Pattern | Syntax | vs. Alternative |
| :--- | :--- | :--- |
| **`EXISTS`** | `WHERE EXISTS (SELECT 1 FROM ...)` | Faster than `IN` when subquery result is large; short-circuits on first match |
| **`NOT EXISTS`** | `WHERE NOT EXISTS (SELECT 1 FROM ...)` | Safer than `NOT IN` — handles NULLs correctly |

> **Critical Gotcha:** `NOT IN` returns **no rows** if the subquery contains any `NULL`. `NOT EXISTS` handles NULLs safely and is almost always the better choice.

<details>
<summary><b>View EXISTS / NOT EXISTS Examples</b></summary>

```sql
-- 1. EXISTS: Find customers who placed at least one order
SELECT c.customer_id, c.name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- 2. NOT EXISTS: Find customers who have NEVER placed an order (safe NULL handling)
SELECT c.customer_id, c.name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);
-- Preferred over NOT IN when subquery might return NULLs

-- 3. NOT IN pitfall (DANGEROUS if subquery has NULLs):
SELECT customer_id FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);
-- If any customer_id in orders is NULL, this returns 0 rows!

-- 4. EXISTS with correlated subquery: Products that were sold in every region
SELECT p.product_id, p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM regions r
    WHERE NOT EXISTS (
        SELECT 1 FROM sales s
        WHERE s.product_id = p.product_id AND s.region_id = r.region_id
    )
);
```
</details>

---

## 17. Collection Aggregation (STRING_AGG, GROUP_CONCAT, ARRAY_AGG)

| Function | MySQL | PostgreSQL | SQL Server | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Concat to string** | `GROUP_CONCAT(col ORDER BY col SEPARATOR ', ')` | `STRING_AGG(col, ', ' ORDER BY col)` | `STRING_AGG(col, ', ') WITHIN GROUP (ORDER BY col)` | Collapse many rows into one comma-separated string |
| **Aggregate to array** | *(not native)* | `ARRAY_AGG(col ORDER BY col)` | *(not native)* | Collapse rows into a SQL array |
| **Count distinct** | `COUNT(DISTINCT col)` | `COUNT(DISTINCT col)` | `COUNT(DISTINCT col)` | Count unique values — already in Section 3 |

<details>
<summary><b>View Collection Aggregation Examples</b></summary>

```sql
-- 1. STRING_AGG (PostgreSQL / SQL Server): List all skills per employee as a string
SELECT employee_id,
       STRING_AGG(skill, ', ' ORDER BY skill) AS all_skills
FROM employee_skills
GROUP BY employee_id;
-- Result: emp_id=1 → "Excel, Python, SQL"

-- 2. GROUP_CONCAT (MySQL): Same pattern
SELECT employee_id,
       GROUP_CONCAT(skill ORDER BY skill SEPARATOR ', ') AS all_skills
FROM employee_skills
GROUP BY employee_id;

-- 3. ARRAY_AGG (PostgreSQL): Aggregate into a true array for array operations
SELECT department_id,
       ARRAY_AGG(emp_name ORDER BY salary DESC) AS employees_by_salary
FROM employees
GROUP BY department_id;

-- 4. Interview Pattern: Find employees who hold multiple roles (using GROUP_CONCAT / STRING_AGG)
SELECT employee_id,
       COUNT(role) AS num_roles,
       STRING_AGG(role, ', ') AS roles_held
FROM employee_roles
GROUP BY employee_id
HAVING COUNT(role) > 1;

-- 5. De-duplicate and join values (PostgreSQL)
SELECT department_id,
       STRING_AGG(DISTINCT emp_name, ', ' ORDER BY emp_name) AS unique_employees
FROM assignments
GROUP BY department_id;
```
</details>

---

## 18. Statistical & Percentile Functions

| Function | Syntax | Purpose | Support |
| :--- | :--- | :--- | :--- |
| **`STDDEV(col)`** | `STDDEV(salary)` | Population standard deviation | MySQL, PostgreSQL, SQL Server (`STDEV`) |
| **`VARIANCE(col)`** | `VARIANCE(salary)` | Population variance | MySQL, PostgreSQL, SQL Server (`VAR`) |
| **`STDDEV_SAMP(col)`** | `STDDEV_SAMP(salary)` | Sample standard deviation (Bessel's correction) | MySQL, PostgreSQL |
| **`PERCENTILE_CONT(p)`** | `PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary)` | Continuous percentile (interpolates) — **median** | PostgreSQL, SQL Server |
| **`PERCENTILE_DISC(p)`** | `PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY salary)` | Discrete percentile (returns an actual row value) | PostgreSQL, SQL Server |
| **`CORR(x, y)`** | `CORR(price, units_sold)` | Pearson correlation coefficient | PostgreSQL |
| **`REGR_SLOPE(y, x)`** | `REGR_SLOPE(revenue, units)` | Slope of linear regression line | PostgreSQL |

<details>
<summary><b>View Statistical Function Examples</b></summary>

```sql
-- 1. STDDEV & VARIANCE: Measure salary spread by department
SELECT department,
       ROUND(AVG(salary), 2)      AS avg_salary,
       ROUND(STDDEV(salary), 2)   AS salary_stddev,
       ROUND(VARIANCE(salary), 2) AS salary_variance
FROM employees
GROUP BY department;

-- 2. PERCENTILE_CONT: Compute median salary (continuous interpolation) — PostgreSQL / SQL Server
SELECT department,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
FROM employees
GROUP BY department;

-- 3. PERCENTILE_DISC: Compute 75th percentile (returns an actual observed salary value)
SELECT PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY salary) AS p75_salary
FROM employees;

-- 4. MySQL Median workaround (no PERCENTILE_CONT):
-- Use the ROW_NUMBER dual-rank trick (see Section 8 for full pattern)
WITH ranked AS (
    SELECT salary,
           ROW_NUMBER() OVER (ORDER BY salary ASC)  AS rn_asc,
           ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn_desc
    FROM employees
)
SELECT AVG(salary) AS median_salary
FROM ranked
WHERE ABS(rn_asc - rn_desc) <= 1;

-- 5. CORR: Correlation between price and quantity sold (PostgreSQL)
SELECT ROUND(CORR(price, units_sold)::NUMERIC, 4) AS price_units_correlation
FROM product_sales;
-- Result near +1: strong positive correlation; near -1: inverse; near 0: no linear relationship

-- 6. STDDEV as a window function (detect outliers)
SELECT emp_name, salary,
       AVG(salary)    OVER (PARTITION BY department) AS dept_avg,
       STDDEV(salary) OVER (PARTITION BY department) AS dept_stddev
FROM employees;
-- Outlier if: ABS(salary - dept_avg) > 2 * dept_stddev
```
</details>

---

## 19. QUALIFY (Snowflake / BigQuery)

`QUALIFY` is a Snowflake/BigQuery-specific clause that filters the results of **window functions directly**, without needing a subquery or CTE. It is evaluated after `WHERE`, `GROUP BY`, and `HAVING`.

```sql
-- Standard approach (any dialect) — requires a subquery:
SELECT user_id, spend, transaction_date
FROM (
    SELECT user_id, spend, transaction_date,
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rn
    FROM transactions
) x
WHERE rn = 3;

-- Snowflake / BigQuery shorthand using QUALIFY (no subquery needed):
SELECT user_id, spend, transaction_date
FROM transactions
QUALIFY ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) = 3;
```

| Clause Execution Order | Purpose |
| :--- | :--- |
| `WHERE` | Filters raw rows |
| `GROUP BY` + `HAVING` | Groups and filters aggregates |
| Window functions | Computed after grouping |
| **`QUALIFY`** | **Filters on window function results** |

---

## 20. Consecutive Streaks & Active Days (Classic Interview Pattern)

Finding users with activity on consecutive days (e.g. "active for 3 consecutive days") is one of the most popular interview questions.

### Method 1: Chained `LEAD` / `LAG` (Best for fixed count of days, e.g., 3 days)
This method grabs the next and the day-after-next event dates per user. If the date differences are exactly 1 and 2, the user has 3 consecutive active days.

```sql
-- Google consecutive purchases: Users with purchases on 3 consecutive days
-- File: Real Interview Questions/Amazon, Swiggy, Flipkart Questions/Readme.md
WITH cte AS (
    SELECT user_id, purchase_date,
           LEAD(purchase_date, 1) OVER(PARTITION BY user_id ORDER BY purchase_date) AS next_day,
           LEAD(purchase_date, 2) OVER(PARTITION BY user_id ORDER BY purchase_date) AS day_after_next
    FROM (SELECT DISTINCT user_id, purchase_date FROM purchases) unique_purchases
)
SELECT DISTINCT user_id
FROM cte
-- MySQL:
WHERE DATEDIFF(next_day, purchase_date) = 1 
  AND DATEDIFF(day_after_next, purchase_date) = 2;

-- PostgreSQL / Standard SQL:
-- WHERE (next_day - purchase_date) = 1 AND (day_after_next - purchase_date) = 2;
```

---

### Method 2: Date - Row Number Trick (General solution for streaks of length N)
Subtracting the sequential row number (`1, 2, 3...`) from the event date creates a **constant group identifier date** for any contiguous sequence of days. 

If you log in on `2026-03-01` (Row 1), `2026-03-02` (Row 2), and `2026-03-03` (Row 3):
- `2026-03-01 - 1 day = 2026-02-28`
- `2026-03-02 - 2 days = 2026-02-28`
- `2026-03-03 - 3 days = 2026-02-28`
All rows in this streak map to `2026-02-28`. You can then group by `user_id` and this identifier to count streak lengths!

```sql
-- General Gaps & Islands Solution: Find users with a streak of 3+ consecutive active days
WITH unique_logins AS (
    SELECT DISTINCT user_id, CAST(login_time AS DATE) AS login_date
    FROM user_activity
),
ranked_logins AS (
    SELECT user_id, login_date,
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY login_date) AS rn
    FROM unique_logins
),
streaks AS (
    SELECT user_id,
           -- Subtracting the row number from date to group continuous streaks
           -- PostgreSQL:
           login_date - CAST(rn || ' days' AS INTERVAL) AS streak_id,
           -- MySQL:
           -- DATE_SUB(login_date, INTERVAL rn DAY) AS streak_id,
           -- SQL Server:
           -- DATEADD(day, -rn, login_date) AS streak_id,
           COUNT(*) AS streak_length
    FROM ranked_logins
    GROUP BY user_id, streak_id
)
SELECT DISTINCT user_id
FROM streaks
WHERE streak_length >= 3;
```


