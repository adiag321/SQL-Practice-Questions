## Show ROW_NUMBER vs RANK vs DENSE_RANK Difference

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Window Functions · Fundamentals |
| **Companies** | Any |

---

#### Problem Statement

Using the `orders` table, rank users by their total spend (descending) using `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`.

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
SELECT 
user_id, 
SUM(amount) AS spend,
ROW_NUMBER() OVER(ORDER BY SUM(amount) DESC) AS row_num,
RANK() OVER(ORDER BY SUM(amount) DESC) AS rank,
DENSE_RANK() OVER(ORDER BY SUM(amount) DESC) AS dense_rank
FROM orders 
GROUP BY user_id
order by spend desc
```

---

#### Sample Output

| user_id | spend  | row_num | rank | dense_rank |
|---------|--------|---------|------|------------|
| 3 | 239.97 | 1 | 1 | 1 |
| 1 | 119.97 | 2 | 2 | 2 |
| 5 | 109.98 | 3 | 3 | 3 |
| 4 | 59.99  | 4 | 4 | 4 |
| 8 | 44.99  | 5 | 5 | 5 |
| 7 | 34.99  | 6 | 6 | 6 |
