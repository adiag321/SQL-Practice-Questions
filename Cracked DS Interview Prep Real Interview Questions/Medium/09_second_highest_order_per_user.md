## Second highest order per user

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions |
| **Companies** | Google |

---

#### Problem Statement

Find the second highest order amount for each user from the `orders` table.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| user_id | INT |
| order_date | DATE |
| amount | NUMERIC |

```sql
CREATE TABLE orders (
  user_id INT,
  order_date DATE,
  amount NUMERIC
);

INSERT INTO orders (user_id, order_date, amount) VALUES
(1, '2024-03-10', 19.99),
(1, '2024-03-15', 39.99),
(1, '2024-03-20', 29.99),
(2, '2024-03-05', 15.00),
(3, '2024-03-22', 49.99),
(3, '2024-03-28', 89.99),
(3, '2024-03-30', 79.99),
(4, '2024-03-25', 25.00),
(5, '2024-03-18', 29.99);
```

---

#### Solution

```sql
-- 2nd highest order per user
WITH rnk_orders AS (
  SELECT
    user_id,
    order_date,
    amount,
    rank() OVER (PARTITION BY user_id ORDER BY amount DESC) AS rnk
  FROM orders
)

SELECT
  user_id,
  order_date,
  amount
FROM rnk_orders
WHERE rnk = 2;
```

---

#### Sample Output

| user_id | order_date | amount |
|---------|------------|--------|
| 1       | 2024-03-15 | 39.99  |
| 3       | 2024-03-28 | 89.99  |
| 5       | 2024-03-20 | 29.99  |
