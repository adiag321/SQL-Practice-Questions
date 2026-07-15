## Most expensive order per user ranked overall.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions |
| **Companies** | Amazon |

---

#### Problem Statement

Find the most expensive order for each user and then rank these orders overall by their amount.

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
SELECT
user_id,
order_date,
amount,
RANK() OVER(ORDER BY amount DESC) AS overall_rank
FROM (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY amount DESC) AS rn
FROM orders
)
WHERE rn=1;
```

---

#### Explanation

This query first identifies the most expensive order for each user using a subquery with `ROW_NUMBER()` and then ranks these unique most expensive orders based on their `amount` in descending order.

- The inner subquery assigns a row number (`rn`) to each order within each `user_id` partition, ordered by `amount` in descending order. The `rn=1` filter selects only the most expensive order per user.
- The outer query then applies `RANK()` on these filtered results (the most expensive order per user) based on the `amount` to get an overall ranking of these top orders.

---

#### Sample Output

| user_id | order_date | amount | overall_rank |
|---------|------------|--------|--------------|
| 3       | 2024-01-25 | 99.99  | 1            |
| 5       | 2024-03-01 | 79.99  | 2            |
| 4       | 2024-03-10 | 59.99  | 3            |
| 1       | 2024-01-15 | 49.99  | 4            |
| 8       | 2024-03-05 | 44.99  | 5            |
| 7       | 2024-02-28 | 34.99  | 6            |
