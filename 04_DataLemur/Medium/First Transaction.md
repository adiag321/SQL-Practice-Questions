## First Transaction

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | CTE · Window Functions |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/first-transaction |

---

#### Problem Statement

Find the number of distinct users who made their **first transaction** (i.e., the earliest transaction per user) with a spend of at least $50.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS user_transactions;

CREATE TABLE user_transactions (
    transaction_id INTEGER,
    user_id        INTEGER,
    spend          DECIMAL(10,2),
    transaction_date DATE
);

INSERT INTO user_transactions (transaction_id, user_id, spend, transaction_date) VALUES
(1, 101, 45.00, '2022-01-10'),
(2, 101, 55.00, '2022-02-15'),
(3, 102, 30.00, '2022-01-05'),
(4, 102, 70.00, '2022-03-20'),
(5, 103, 60.00, '2022-02-01');
```

---

#### Solution

```sql
WITH ct AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rn
    FROM user_transactions
)
SELECT COUNT(DISTINCT user_id) AS users
FROM ct
WHERE rn = 1 AND spend >= 50;
```

---

#### Sample Output

| users |
|------|
| 2 |
