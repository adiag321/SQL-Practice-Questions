## Apple Pay Volume

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · CASE WHEN · LOWER |
| **Companies** | Apple |
| **Link** | https://datalemur.com/questions/apple-pay-volume |

---

#### Problem Statement

Write a query to calculate the total transaction volume for each merchant that used **Apple Pay**, ordered by total Apple Pay volume in descending order.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    merchant_id        INTEGER,
    transaction_amount DECIMAL(10, 2),
    payment_method     VARCHAR(50)
);

INSERT INTO transactions (merchant_id, transaction_amount, payment_method) VALUES
(1, 150.00, 'Apple Pay'),
(1,  50.00, 'Visa'),
(1, 200.00, 'APPLE PAY'),
(2, 300.00, 'Apple Pay'),
(2, 100.00, 'Mastercard'),
(3,  75.00, 'PayPal'),
(3,  25.00, 'Visa');
-- Merchant 3 has no Apple Pay → should appear as 0 or be excluded
```

---

#### Solution

```sql
SELECT merchant_id,
    SUM(CASE WHEN LOWER(payment_method) = 'apple pay' THEN transaction_amount ELSE 0 END) AS total_transaction
FROM transactions
GROUP BY merchant_id
ORDER BY total_transaction DESC;
```

---

#### Sample Output

| merchant_id | total_transaction |
|-------------|-------------------|
| 2           | 300.00            |
| 1           | 350.00            |
| 3           | 0.00              |
