## Cumulative revenue over time.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Running Total |
| **Companies** | Any |

---

#### Problem Statement

Calculate cumulative revenue over time.

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

```sql
CREATE TABLE orders (
    order_id   INT PRIMARY KEY,
    user_id    INT,
    order_date DATE,
    amount     DECIMAL(10,2),
    product_id INT
);
```

---

#### Solution

```sql
-- Cumulative revenue
SELECT
order_date,
amount,
SUM(amount) OVER(ORDER BY order_date ROWS UNBOUNDED PRECEDING) AS cum
FROM orders
ORDER BY order_date;
```

---

#### Sample Output

| order_date | amount | cum |
|------------|--------|-----|
| 2024-01-15 | 49.99  | 49.99 |
| 2024-01-20 | 19.99  | 69.98 |
| 2024-01-25 | 99.99  | 169.97 |
| 2024-02-10 | 29.99  | 199.96 |
| 2024-02-25 | 49.99  | 249.95 |
| 2024-02-28 | 34.99  | 284.94 |
