## Find users whose average order amount exceeds the overall average

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Subqueries · Having |
| **Companies** | Any |

---

#### Problem Statement

Find users whose average order amount exceeds the overall average order amount across all users. This helps identify high-value customers who spend more than the typical user.

---

#### Tables Used

**`users`**

| Column | Type |
|--------|------|
| user_id | INT (PK) |
| signup_date | DATE |
| country | TEXT |
| plan | TEXT |

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT (PK) |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL |

```sql
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  signup_date DATE,
  country TEXT,
  plan TEXT
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  user_id INT,
  order_date DATE,
  amount DECIMAL
);

INSERT INTO users (user_id, signup_date, country, plan) VALUES
(1, '2023-01-10', 'US', 'premium'),
(2, '2023-02-15', 'UK', 'basic'),
(3, '2023-01-20', 'US', 'premium'),
(4, '2023-03-10', 'CA', 'basic'),
(5, '2023-04-01', 'US', 'premium');

INSERT INTO orders (order_id, user_id, order_date, amount) VALUES
(1, 1, '2024-01-15', 49.99),
(2, 1, '2024-02-14', 69.98),
(3, 2, '2024-01-20', 19.99),
(4, 3, '2024-01-25', 79.99),
(5, 3, '2024-02-10', 79.99),
(6, 3, '2024-03-05', 80.01),
(7, 4, '2024-03-10', 59.99),
(8, 5, '2024-03-01', 54.99),
(9, 5, '2024-03-20', 55.00);
```

---

#### Solution

```sql
-- Users with above-average order amounts
select
  user_id,
  avg(amount) as order_avg_per_user,
  (select avg(amount) from orders) as avg_order
from orders
group by 1
having avg(amount) > (select avg(amount) from orders)
```

---

#### Sample Output

| user_id | order_avg_per_user | avg_order |
|---------|------------------|-----------|
| 3       | 79.99            | 52.49     |
| 4       | 59.99            | 52.49     |
| 5       | 54.98999999999995 | 52.49     |

---
