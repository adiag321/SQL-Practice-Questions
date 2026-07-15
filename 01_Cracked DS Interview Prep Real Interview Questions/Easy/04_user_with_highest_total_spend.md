## Find the User Who Spent the Most Total Amount

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · Basics |
| **Companies** | Any |

---

#### Problem Statement

Find the user who has spent the highest total amount across all their orders.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT (PK) |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL |
| product_id | INT |

---

#### Solution

```sql
-- User with highest total spend
SELECT user_id, SUM(amount) AS total_spent
FROM orders
GROUP BY user_id
ORDER BY total_spent DESC
LIMIT 1;
```

---

#### Sample Output

| user_id | total_spent |
|---------|-------------|
| 3       | 239.97      |
