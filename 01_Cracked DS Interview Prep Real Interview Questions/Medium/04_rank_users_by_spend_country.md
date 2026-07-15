## Rank users by total spend within each country

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Ranking |
| **Companies** | Amazon · Uber |

---

#### Problem Statement

Rank users by their total spending within each country. This helps identify the top spenders in different geographical regions and understand customer value distribution by location.

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
(6, '2023-04-05', 'UK', 'premium'),
(8, '2023-05-10', 'CA', 'basic');

INSERT INTO orders (order_id, user_id, order_date, amount) VALUES
(1, 1, '2024-01-15', 49.99),
(2, 1, '2024-02-14', 69.98),
(3, 2, '2024-01-20', 19.99),
(4, 3, '2024-01-25', 79.99),
(5, 3, '2024-02-10', 79.99),
(6, 3, '2024-03-05', 80.01),
(7, 4, '2024-03-10', 59.99),
(8, 8, '2024-03-01', 44.99);
```

---

#### Solution

```sql
-- Rank users by spend within country
select
  u.user_id,
  u.country,
  sum(amount) as total_spent,
  rank() over(partition by country order by sum(amount) desc) as rnk
from users as u
left join orders as o
  on u.user_id = o.user_id
group by 1, 2;
```

---

#### Sample Output

| user_id | country | total_spent | rnk |
|---------|---------|-------------|-----|
| 4       | CA      | 59.99       | 1   |
| 8       | CA      | 44.99       | 2   |
| 2       | UK      | 19.99       | 1   |
| 6       | UK      | NULL        | 2   |
| 3       | US      | 239.96999999999997 | 1   |
| 1       | US      | 119.97      | 2   |

---
