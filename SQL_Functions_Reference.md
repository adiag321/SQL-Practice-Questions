# SQL Functions Reference Guide
> **30_Days_SQL_Challenge** — Quick Reference & Interview Patterns (Amazon, Uber, IBM, Facebook, Flipkart & more)

## 1. Window Functions
*Compute values across a set of rows related to the current row without collapsing them.*

### Ranking Functions
| Function | Syntax | Ties Handling |
| :--- | :--- | :--- |
| **`ROW_NUMBER()`** | `ROW_NUMBER() OVER(...)` | Unique sequential integer |
| **`RANK()`** | `RANK() OVER(...)` | Same rank for ties |
| **`DENSE_RANK()`** | `DENSE_RANK() OVER(...)` | Same rank for ties |

<details>
<summary><b>View Ranking Examples</b></summary>

```sql
-- 1. Find the 3rd transaction of every user (Uber - 05.sql)
SELECT user_id, spend, transaction_date
FROM (
    SELECT user_id, spend, transaction_date,
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rn
    FROM transactions
) x1
WHERE rn = 3;

-- 2. Find top 3 salary earners in each department (LeetCode - 09.sql)
SELECT department_name, emp_name, salary
FROM (
    SELECT d.name AS department_name, e.name AS emp_name, e.salary,
           DENSE_RANK() OVER(PARTITION BY d.name ORDER BY e.salary DESC) AS drn
    FROM employee e
    JOIN department d ON e.departmentId = d.id
) x1
WHERE drn <= 3;
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
-- 1. Compare product revenue to previous year (Amazon - 05.sql)
WITH prev_rev AS (
    SELECT *,
        LAG(revenue) OVER(PARTITION BY product_name ORDER BY year) AS prev_year_revenue
    FROM product_revenue
)
SELECT product_name, revenue AS current_year_revenue, prev_year_revenue,
       ROUND(((prev_year_revenue - revenue) / prev_year_revenue) * 100.0, 2) AS pct_decrease
FROM prev_rev
WHERE prev_year_revenue > revenue;

-- 2. 3-day moving average of sales (General pattern)
SELECT order_date, amount,
       AVG(amount) OVER(
           PARTITION BY user_id
           ORDER BY order_date
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS moving_avg_3day
FROM orders;
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

Here is how common real-world interview problems are solved using these different dialect approaches:

#### 1. Extracting Month/Year
*Extracting components from dates for grouping and filtering.*
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
*Finding records that happen within a certain time window of a previous event.*
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
*Summarize data groups and execute branching (if-else) logic.*

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
*Clean missing records, prevent errors (like division-by-zero), and format calculations.*

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
*Sleek text transformations and matching pattern techniques.*

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
*Simplify nested architectures into clean, modular query layers.*

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
- **Anti-Join:** `WHERE col NOT IN (SELECT DISTINCT col FROM table)` (filters out matches)
- **Derived Table:** `SELECT * FROM (SELECT ... ) x1` (always alias nested subqueries in `FROM`)
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
*Combine datasets accurately based on relation models.*

- **Anti-Join (`LEFT JOIN ... WHERE B.col IS NULL`):** Find non-matching records (e.g. users who never purchased).
- **Self-Join (`JOIN` a table to itself):** Query hierarchies (manager/employee) or compare sequential rows.
- **Cross-Join (`CROSS JOIN`):** Cartesian product (all combinations) for matrix generation.

<details>
<summary><b>View Join Examples</b></summary>

```sql
-- 1. Anti-Join: Pages with zero likes (Facebook - 02.sql)
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes pl ON p.page_id = pl.page_id
WHERE pl.page_id IS NULL;

-- 2. Self-Join: Manager-Employee hierarchy lookup (TCS - 22.sql)
SELECT e1.emp_name AS employee, e2.emp_name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.emp_id;
```
</details>

---

## 8. Median — Classic Interview Pattern
*Standard SQL lacks a native `MEDIAN()` function. Use the double `ROW_NUMBER()` ascending/descending difference trick.*

**Logic:** The median row has absolute difference between its ascending and descending rank $\le 1$ (handles both odd and even counts).

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
