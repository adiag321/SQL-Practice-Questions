## User's Third Transaction

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Ranking |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/users-third-transaction |

---

#### Problem Statement

For each `user_id`, return the **third** transaction (ordered by `transaction_date`). Output `user_id`, `spend`, and `transaction_date`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    transaction_id   INTEGER PRIMARY KEY,
    user_id          INTEGER,
    spend            DECIMAL(10,2),
    transaction_date DATE
);

INSERT INTO transactions (transaction_id, user_id, spend, transaction_date) VALUES
(1, 101, 20.00, '2022-01-01'),
(2, 101, 35.00, '2022-01-10'),
(3, 101, 50.00, '2022-01-20'), -- third transaction for 101
(4, 101, 60.00, '2022-02-01'),
(5, 102, 15.00, '2022-01-05'),
(6, 102, 25.00, '2022-01-15'),
(7, 102, 45.00, '2022-01-25'), -- third transaction for 102
(8, 103, 10.00, '2022-01-03');
```

---

#### Solution

```sql
SELECT user_id,
       spend,
       transaction_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rn
    FROM transactions
) t
WHERE rn = 3;
```

---

#### Sample Output

| user_id | spend | transaction_date |
|--------|-------|------------------|
| 101    | 50.00 | 2022-01-20 |
| 102    | 45.00 | 2022-01-25 |
