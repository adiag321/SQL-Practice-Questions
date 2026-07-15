## Calculate cumulative revenue over time.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions, Running Total |
| **Companies** | Any |

---

#### Problem Statement

Calculate the cumulative revenue over time, including the month of the order.

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
strftime('%m', order_date) as month,
sum(amount) over(order by (order_date) asc) as cum_sum
FROM orders;
```

---

#### Sample Output

| order_date | amount | month | cum_sum |
|------------|--------|-------|---------|
| 2024-01-15 | 49.99  | 01    | 49.99   |
| 2024-01-20 | 19.99  | 01    | 69.98   |
| 2024-01-25 | 99.99  | 01    | 169.97  |
| 2024-02-10 | 29.99  | 02    | 199.96  |
| 2024-02-25 | 49.99  | 02    | 249.95  |
| 2024-02-28 | 34.99  | 02    | 284.94  |
