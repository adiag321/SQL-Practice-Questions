## Rank users by spend within country

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions |
| **Companies** | Uber |

---

#### Problem Statement

Rank users by spend within country.

---

#### Table Used

**`users`**

| Column | Type |
|--------|------|
| user_id | INT |
| country | TEXT |

**`orders`**

| Column | Type |
|--------|------|
| user_id | INT |
| amount | NUMERIC |

```sql
CREATE TABLE users (
    user_id INT,
    country TEXT
);

CREATE TABLE orders (
    user_id INT,
    amount NUMERIC
);
```

---

#### Solution

```sql
-- Rank by spend per country
SELECT
u.country,
o.user_id,
SUM(o.amount) AS spend,
RANK() OVER(PARTITION BY u.country ORDER BY SUM(o.amount) DESC) AS rk
FROM orders o
JOIN users u
ON o.user_id=u.user_id
GROUP BY u.country, o.user_id;
```

---

#### Sample Output

| country | user_id | spend | rk |
|---------|---------|-------|----|
| CA      | 4       | 59.99 | 1  |
| CA      | 8       | 44.99 | 2  |
| UK      | 2       | 19.99 | 1  |
| US      | 3       | 239.96999999999997 | 1  |
| US      | 1       | 119.97 | 2  |
| US      | 5       | 109.97999999999999 | 3  |
