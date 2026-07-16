## Y-on-Y Growth Rate

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Tags** | CTE · LAG · Window Functions |
| **Companies** | Wayfair |
| **Link** | https://datalemur.com/questions/yoy-growth-rate |

---

#### Problem Statement

Assume you're given a table containing information about Wayfair user transactions for different products. Write a query to calculate the **year-on-year (YoY) growth rate** for the total spend of each product, grouped by product ID.

Output the following columns:
- `year` – the transaction year
- `product_id`
- `curr_year_spend` – total spend in the current year
- `prev_year_spend` – total spend in the previous year (`NULL` for the first year)
- `yoy_rate` – `(curr - prev) / prev * 100`, rounded to 2 decimal places

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS user_transactions;

CREATE TABLE user_transactions (
    transaction_id   INTEGER,
    product_id       INTEGER,
    spend            DECIMAL(10, 2),
    transaction_date TIMESTAMP
);

INSERT INTO user_transactions (transaction_id, product_id, spend, transaction_date) VALUES
-- Product 123424: 4 years of data → 3 YoY rates + 1 NULL
(1341, 123424, 1500.60, '2019-12-31 12:00:00'),
(1423, 123424,  455.60, '2020-12-31 12:00:00'),
(1623, 123424,  258.30, '2021-12-31 12:00:00'),
(1322, 123424,  520.00, '2022-12-31 12:00:00'),
-- Product 234412: 3 years of data → 2 YoY rates + 1 NULL
(1341, 234412, 2000.00, '2020-12-31 12:00:00'),
(1423, 234412, 1800.50, '2021-12-31 12:00:00'),
(1534, 234412, 1950.75, '2022-12-31 12:00:00');
```

---

#### Solution

```sql
WITH CTE AS (
    SELECT
        DATE_PART('year', transaction_date) AS year,
        product_id,
        spend AS curr_year_spend,
        LAG(spend) OVER (
            PARTITION BY product_id
            ORDER BY transaction_date
        ) AS prev_year_spend
    FROM user_transactions
)

SELECT
    *,
    ROUND(
        (curr_year_spend - prev_year_spend) / prev_year_spend * 100,
        2
    ) AS yoy_rate
FROM CTE;
```

---

#### Sample Output

| year | product_id | curr_year_spend | prev_year_spend | yoy_rate |
|------|------------|-----------------|-----------------|----------|
| 2019 | 123424     | 1500.60         | NULL            | NULL     |
| 2020 | 123424     | 455.60          | 1500.60         | -69.63   |
| 2021 | 123424     | 258.30          | 455.60          | -43.31   |
| 2022 | 123424     | 520.00          | 258.30          | 101.32   |
| 2020 | 234412     | 2000.00         | NULL            | NULL     |
| 2021 | 234412     | 1800.50         | 2000.00         | -9.98    |
| 2022 | 234412     | 1950.75         | 1800.50         | 8.35     |
