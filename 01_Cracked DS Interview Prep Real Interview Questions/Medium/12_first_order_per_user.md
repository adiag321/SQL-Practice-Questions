## First order per user.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions |
| **Companies** | Amazon |

---

#### Problem Statement

Find the first order for each user.

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
-- First order per user
select
*
from (select
*,
row_number() over(partition by user_id order by order_date asc) as rnk
from orders
    ) as temp
where temp.rnk = 1
```

---

#### Sample Output

| order_id | user_id | order_date | amount | product_id | rnk |
|----------|---------|------------|--------|------------|-----|
| 1        | 1       | 2024-01-15 | 49.99  | 101        | 1   |
| 3        | 2       | 2024-01-20 | 19.99  | 101        | 1   |
| 4        | 3       | 2024-01-25 | 99.99  | 103        | 1   |
| 8        | 4       | 2024-03-10 | 59.99  | 101        | 1   |
| 6        | 5       | 2024-03-01 | 79.99  | 102        | 1   |
| 12       | 7       | 2024-02-28 | 34.99  | 102        | 1   |
| 11       | 8       | 2024-03-05 | 44.99  | 101        | 1   |
