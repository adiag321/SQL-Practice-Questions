## Histogram of Users and Purchases

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Ranking |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/histogram-of-users-and-purchases |

---

#### Problem Statement

For each user, identify the most recent transaction (by `transaction_date`) and count how many products they purchased in that transaction. Return `transaction_date`, `user_id`, and `purchase_count` ordered by `transaction_date`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS user_transactions;

CREATE TABLE user_transactions (
    user_id          INTEGER,
    transaction_date DATE,
    product_id       INTEGER
);

INSERT INTO user_transactions (user_id, transaction_date, product_id) VALUES
(101, '2022-01-10', 1),
(101, '2022-01-10', 2),
(101, '2022-02-15', 3),
(102, '2022-01-05', 4),
(102, '2022-01-05', 5),
(102, '2022-03-20', 6),
(103, '2022-02-01', 7);
```

---

#### Solution

```sql
WITH cte AS (
    SELECT user_id,
           transaction_date,
           product_id,
           DENSE_RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS rnk
    FROM user_transactions
)
SELECT transaction_date,
       user_id,
       COUNT(product_id) AS purchase_count
FROM cte
WHERE rnk = 1
GROUP BY transaction_date, user_id
ORDER BY transaction_date;
```

---

#### Sample Output

| transaction_date | user_id | purchase_count |
|------------------|---------|----------------|
| 2022-01-10       | 101     | 2 |
| 2022-01-05       | 102     | 2 |
| 2022-02-01       | 103     | 1 |
