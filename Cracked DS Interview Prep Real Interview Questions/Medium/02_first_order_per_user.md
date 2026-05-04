## Find the first order date and amount for each user

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · First Value |
| **Companies** | Amazon |

---

#### Problem Statement

Find the first order date and amount for each user. This helps identify when each user made their initial purchase and the corresponding transaction amount.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL |

```sql
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  user_id INT,
  order_date DATE,
  amount DECIMAL
);

INSERT INTO orders (order_id, user_id, order_date, amount) VALUES
(1, 1, '2024-01-15', 49.99),
(2, 1, '2024-02-14', 29.99),
(3, 2, '2024-01-20', 19.99),
(4, 2, '2024-03-05', 39.99),
(5, 3, '2024-01-25', 99.99),
(6, 3, '2024-02-10', 79.99),
(7, 4, '2024-03-10', 59.99),
(8, 5, '2024-03-01', 79.99),
(9, 5, '2024-03-20', 49.99),
(10, 7, '2024-02-28', 34.99);
```

---

#### Solution

```sql
-- First order per user
with first_order_info as (
  SELECT
    *,
    row_number() over(partition by user_id order by order_date) as rnk
  from orders
)
select
  user_id,
  order_date as first_order_date,
  amount as first_order_amt
from first_order_info
where rnk = 1
```

---

#### Sample Output

| user_id | first_order_date | first_order_amt |
|---------|------------------|-----------------|
| 1       | 2024-01-15       | 49.99           |
| 2       | 2024-01-20       | 19.99           |
| 3       | 2024-01-25       | 99.99           |
| 4       | 2024-03-10       | 59.99           |
| 5       | 2024-03-01       | 79.99           |
| 7       | 2024-02-28       | 34.99           |

---
