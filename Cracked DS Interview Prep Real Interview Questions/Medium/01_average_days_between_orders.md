## Average days between orders per user

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Aggregation |
| **Companies** | DoorDash · Uber |

---

#### Problem Statement

Calculate the average days between orders for each user. This helps understand the frequency of user purchases by finding the average time gap between consecutive orders.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| user_id | INT |
| order_date | DATE |

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
(3, 3, '2024-01-20', 79.99),
(4, 3, '2024-02-20', 99.99),
(5, 5, '2024-02-01', 59.99),
(6, 5, '2024-02-20', 39.99),
(7, 8, '2024-01-10', 149.99),
(8, 7, '2024-03-05', 34.99),
(9, 4, '2024-02-15', 89.99);
```

---

#### Solution

```sql
-- Avg days between orders per user
select
  user_id,
  round(avg(julianday(order_date) - julianday(prev_day)), 2) as diff
from (SELECT *,
  lag(order_date) over(partition by user_id order by order_date) as prev_day
  from orders
  ) as temp
group by 1
order by diff desc
```

---

#### Sample Output

| user_id | diff |
|---------|------|
| 3       | 31.5 |
| 1       | 30   |
| 5       | 19   |
| 8       | NULL |
| 7       | NULL |
| 4       | NULL |

---
