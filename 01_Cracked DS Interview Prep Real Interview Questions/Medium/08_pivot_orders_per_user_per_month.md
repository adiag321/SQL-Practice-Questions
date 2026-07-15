## Pivot orders per user per month

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Pivot · CASE WHEN |
| **Companies** | Any |

---

#### Problem Statement

Pivot the orders table to show the number of orders placed by each user for the first three months of the year. Return one row per user with columns for `jan`, `feb`, and `mar`.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| user_id | INT |
| order_date | DATE |

```sql
CREATE TABLE orders (
  user_id INT,
  order_date DATE
);

INSERT INTO orders (user_id, order_date) VALUES
(1, '2024-01-05'),
(1, '2024-02-10'),
(1, '2024-03-15'),
(2, '2024-01-20'),
(3, '2024-01-12'),
(3, '2024-02-18'),
(3, '2024-03-02'),
(4, '2024-03-22'),
(5, '2024-03-03'),
(5, '2024-03-09'),
(7, '2024-02-07');
```

---

#### Solution

```sql
-- Pivot orders per month
SELECT
  DISTINCT user_id,
  SUM(CASE WHEN strftime('%m', order_date) = '01' THEN 1 ELSE 0 END) AS jan,
  SUM(CASE WHEN strftime('%m', order_date) = '02' THEN 1 ELSE 0 END) AS feb,
  SUM(CASE WHEN strftime('%m', order_date) = '03' THEN 1 ELSE 0 END) AS mar
FROM orders
GROUP BY user_id;
```

---

#### Sample Output

| user_id | jan | feb | mar |
|---------|-----|-----|-----|
| 1       | 1   | 1   | 1   |
| 2       | 1   | 0   | 0   |
| 3       | 1   | 1   | 1   |
| 4       | 0   | 0   | 1   |
| 5       | 0   | 0   | 2   |
| 7       | 0   | 1   | 0   |
