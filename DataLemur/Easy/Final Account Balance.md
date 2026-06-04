## Final Account Balance

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · CASE WHEN · GROUP BY |
| **Companies** | PayPal |
| **Link** | https://datalemur.com/questions/final-account-balance |

---

#### Problem Statement

Given a table of bank transactions, write a query to calculate the **final balance** for each account. Deposits add to the balance; withdrawals subtract from it.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    transaction_id   INTEGER,
    account_id       INTEGER,
    transaction_type VARCHAR(20),  -- 'Deposit' or 'Withdrawal'
    amount           DECIMAL(10, 2)
);

INSERT INTO transactions (transaction_id, account_id, transaction_type, amount) VALUES
(1, 101, 'Deposit',    1000.00),
(2, 101, 'Deposit',     500.00),
(3, 101, 'Withdrawal',  200.00),
-- balance 101 = 1000 + 500 - 200 = 1300
(4, 202, 'Deposit',    2000.00),
(5, 202, 'Withdrawal', 1500.00),
-- balance 202 = 2000 - 1500 = 500
(6, 303, 'Withdrawal',  100.00);
-- balance 303 = -100 (net withdrawal, no deposits)
```

---

#### Solution

```sql
SELECT account_id,
    SUM(CASE WHEN transaction_type = 'Deposit' THEN amount ELSE -amount END) AS final_balance
FROM transactions
GROUP BY account_id;
```

---

#### Sample Output

| account_id | final_balance |
|------------|---------------|
| 101        | 1300.00       |
| 202        | 500.00        |
| 303        | -100.00       |
