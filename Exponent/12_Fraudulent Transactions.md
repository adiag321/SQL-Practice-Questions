## Fraudulent Transactions

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Companies** | Visa |
| **Link** | https://www.tryexponent.com/practice/prepare/fraudulent-transactions |

---

#### Problem Statement

Visa's Anti-Money Laundering (AML) department is responsible for identifying potentially suspicious financial transactions. The AML team has identified suspicious receipt number patterns: `'999'`, `'1234'`, and `'XYZ'`. Customers are flagged as potential money launderers if they have **2 or more** receipts matching these patterns.

Write a SQL query that returns all suspicious receipt numbers made by potential money launderers. Your output should contain the following columns: `first_name`, `last_name`, `receipt_number`, `no_of_offences`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    receipt_number VARCHAR(50),
    amount DECIMAL(10, 2)
);

INSERT INTO customers (customer_id, first_name, last_name) VALUES
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Bob', 'Brown'),
(4, 'Alice', 'Green');

INSERT INTO transactions (transaction_id, customer_id, receipt_number, amount) VALUES
-- John Doe: 2 suspicious → 2 offences (flagged)
(101, 1, 'REC-999-XYZ',  5000.00),
(102, 1, 'REC-XYZ-888', 12000.00),
(103, 1, 'REC-NORMAL-1',   100.00),
-- Jane Smith: 1 suspicious → 1 offence (not flagged)
(104, 2, 'REC-1234-ABC',  8000.00),
(105, 2, 'REC-NORMAL-2',   200.00),
-- Bob Brown: 0 suspicious → not flagged
(106, 3, 'REC-NORMAL-3',   150.00),
-- Alice Green: 3 suspicious → 3 offences (flagged)
(107, 4, 'REC-999-1234', 15000.00),
(108, 4, 'REC-XYZ-999',  20000.00),
(109, 4, 'REC-1234-XYZ', 25000.00);
```

---

#### Solution

```sql
WITH SuspiciousTransactions AS (
    SELECT
        customer_id,
        receipt_number,
        COUNT(*) OVER (PARTITION BY customer_id) AS no_of_offences
    FROM transactions
    WHERE receipt_number LIKE '%999%'
       OR receipt_number LIKE '%1234%'
       OR receipt_number LIKE '%XYZ%'
)
SELECT
    c.first_name,
    c.last_name,
    s.receipt_number,
    s.no_of_offences
FROM customers c
JOIN SuspiciousTransactions s ON c.customer_id = s.customer_id
WHERE s.no_of_offences >= 2;
```

---

#### Sample Output

| first_name | last_name | receipt_number | no_of_offences |
|------------|-----------|----------------|----------------|
| John       | Doe       | REC-999-XYZ    | 2              |
| John       | Doe       | REC-XYZ-888    | 2              |
| Alice      | Green     | REC-999-1234   | 3              |
| Alice      | Green     | REC-XYZ-999    | 3              |
| Alice      | Green     | REC-1234-XYZ   | 3              |