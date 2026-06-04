## Highest Number of Products

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | GROUP BY · HAVING · ORDER BY |
| **Companies** | Walmart |
| **Link** | https://datalemur.com/questions/sql-highest-products |

---

#### Problem Statement

Write a query to find the **top 3 users** who bought the highest number of distinct products, but only consider users whose **total spend is at least $1,000**. Order by product count descending, then total spend descending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS user_transactions;

CREATE TABLE user_transactions (
    transaction_id INTEGER,
    user_id        INTEGER,
    product_id     INTEGER,
    spend          DECIMAL(10, 2)
);

INSERT INTO user_transactions (transaction_id, user_id, product_id, spend) VALUES
(1, 101, 1, 200.00),
(2, 101, 2, 300.00),
(3, 101, 3, 600.00),  -- user 101: 3 products, total 1100 ✓
(4, 102, 1, 150.00),
(5, 102, 2, 400.00),
(6, 102, 3, 500.00),
(7, 102, 4, 200.00),  -- user 102: 4 products, total 1250 ✓
(8, 103, 1,  50.00),
(9, 103, 2, 100.00),  -- user 103: 2 products, total 150 → excluded (< 1000)
(10,104, 1, 500.00),
(11,104, 2, 600.00),  -- user 104: 2 products, total 1100 ✓
(12,105, 1, 300.00),
(13,105, 2, 300.00),
(14,105, 3, 300.00),
(15,105, 4, 200.00);  -- user 105: 4 products, total 1100 ✓
```

---

#### Solution

```sql
SELECT user_id, COUNT(product_id) AS product_num
FROM user_transactions
GROUP BY user_id
HAVING SUM(spend) >= 1000
ORDER BY COUNT(product_id) DESC, SUM(spend) DESC
LIMIT 3;
```

---

#### Sample Output

| user_id | product_num |
|---------|-------------|
| 102     | 4           |
| 105     | 4           |
| 101     | 3           |
