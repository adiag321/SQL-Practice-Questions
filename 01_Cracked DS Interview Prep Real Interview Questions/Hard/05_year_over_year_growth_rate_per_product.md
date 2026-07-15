## Year-over-year growth rate per product.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | HARD |
| **Tags** | YOY GROWTH, WINDOW FUNCTIONS |
| **Companies** | Wayfair, Meta |

---

#### Problem Statement

Calculate the year-over-year growth rate for the total revenue of each product. Return the product ID, year, current year's revenue, previous year's revenue, and the year-over-year growth rate rounded to 2 decimal places.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL(10,2) |
| product_id | INT |

---

#### Solution

```sql
WITH total_sales AS (
SELECT
    product_id,
    date_format(order_date, '%Y-%m') AS month_yr,
    sum(amount) AS total_sold
FROM orders
GROUP BY 1,2
),
hist_sold AS (
SELECT
    product_id,
    month_yr,
    LAG(total_sold) OVER(PARTITION BY product_id ORDER BY month_yr) AS prev_sold
FROM total_sales
)
SELECT
    product_id,
    month_yr,
    total_sold,
    prev_sold,
    ROUND((total_sold - COALESCE(prev_sold, 0)) * 100.00 / COALESCE(prev_sold, 0), 2) AS yoy_growth
FROM hist_sold
```

---

#### Explanation

This query calculates the growth rate for the total revenue of each product.

1.  **`total_sales` CTE**: This CTE groups the `orders` table by `product_id` and month (formatted as `YYYY-MM` using `date_format`), calculating the total revenue (`sum(amount) AS total_sold`) for each product in that period.
2.  **`hist_sold` CTE**: This CTE builds on `total_sales` by using the `LAG` window function to find the previous period's revenue (`prev_sold`). The `OVER` clause partitions the data by `product_id` and orders it chronologically by `month_yr`.
3.  **Final SELECT**: The main query retrieves the product ID, month, current sales, and previous sales. It calculates the growth rate using the formula `((total_sold - prev_sold) / prev_sold) * 100`. The `COALESCE` function is used to handle potential `NULL` values if there were no sales in the previous period, substituting them with 0. The final growth rate is rounded to 2 decimal places.

---

#### Sample Output

| product_id | yr   | rev               | prev | yoy_growth |
|------------|------|-------------------|------|------------|
| 101        | 2024 | 224.9500000000002 | NULL | NULL       |
| 102        | 2024 | 234.9599999999998 | NULL | NULL       |
| 103        | 2024 | 139.98            | NULL | NULL       |
| 104        | 2024 | 29.99             | NULL | NULL       |
