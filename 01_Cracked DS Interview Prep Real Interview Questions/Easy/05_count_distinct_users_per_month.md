## Count Distinct Users Per Month Who Placed Orders

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · Time Series |
| **Companies** | Any |

---

#### Problem Statement

Count the number of distinct users who placed at least one order, grouped by month.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT (PK) |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL |
| product_id | INT |

---

#### Solution

```sql
-- Distinct users per month
SELECT
    strftime('%Y-%m', order_date) AS month,
    COUNT(DISTINCT user_id)       AS unique_buyers
FROM orders
GROUP BY month
ORDER BY month;
```

---

#### Sample Output

| month   | unique_buyers |
|---------|---------------|
| 2023-01 | 3             |
| 2023-02 | 2             |
| 2023-03 | 3             |
| 2023-04 | 3             |
| 2023-05 | 1             |
| 2023-06 | 6             |
| 2023-07 | 4             |
| 2023-08 | 2             |
