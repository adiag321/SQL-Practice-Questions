## Validate Bitcoin Transactions

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Companies** | Exponent |
| **Link** | https://www.tryexponent.com/courses/data-science/sql-interviews/validate-bitcoin-transactions |

---

#### Problem Statement

Blockchains like Bitcoin use the UTXO (Unspent Transaction Outputs) model to track ownership of coins. In this model, each transaction consumes UTXOs as inputs and creates new UTXOs as outputs. However, there can be invalid transactions where:

- The sender does not own the UTXO they're trying to spend.
- The same UTXO has already been used as input in another transaction.

You're given the following tables:

**transactions table:**

| Column | Description |
|--------|-------------|
| transaction_id | unique identifier for each transaction |
| sender | address of the person initiating the transaction |
| timestamp | time when the transaction was created |

**transaction_inputs table:**

| Column | Description |
|--------|-------------|
| input_id | unique identifier for each input within a transaction |
| transaction_id | foreign key referencing transactions |
| utxo_id | foreign key indicating which UTXO is being consumed by this input |

**utxo table:**

| Column | Description |
|--------|-------------|
| utxo_id | unique identifier for the UTXO |
| address | owner of the UTXO |
| amount | amount of cryptocurrency represented by the UTXO |

Given these tables, write a SQL query to identify transactions that are potentially invalid based on the above conditions. Your output should have the following column: `InvalidTransactionId`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS transaction_inputs;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS utxo;

CREATE TABLE utxo (
    utxo_id INTEGER PRIMARY KEY,
    address VARCHAR(100),
    amount NUMERIC
);

CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY,
    sender VARCHAR(100),
    timestamp TIMESTAMP
);

CREATE TABLE transaction_inputs (
    input_id INTEGER PRIMARY KEY,
    transaction_id INTEGER,
    utxo_id INTEGER,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (utxo_id) REFERENCES utxo(utxo_id)
);

-- Sample data
-- UTXOs owned by various addresses
INSERT INTO utxo (utxo_id, address, amount) VALUES
(1, 'addr_A', 5.0),
(2, 'addr_A', 3.0),
(3, 'addr_B', 2.0),
(4, 'addr_C', 10.0),
(5, 'addr_D', 7.0);

-- Transactions
-- Txn 101: VALID - sender 'addr_A' owns utxo 1
-- Txn 102: INVALID - sender 'addr_A' tries to spend utxo 3 (owned by 'addr_B')
-- Txn 103: VALID - sender 'addr_C' owns utxo 4
-- Txn 104: INVALID - utxo 2 already spent by txn 101 (double-spend)
-- Txn 105: VALID - sender 'addr_D' owns utxo 5
INSERT INTO transactions (transaction_id, sender, timestamp) VALUES
(101, 'addr_A', '2024-01-01 10:00:00'),
(102, 'addr_A', '2024-01-01 11:00:00'),
(103, 'addr_C', '2024-01-01 12:00:00'),
(104, 'addr_A', '2024-01-01 13:00:00'),
(105, 'addr_D', '2024-01-01 14:00:00');

-- Transaction inputs
INSERT INTO transaction_inputs (input_id, transaction_id, utxo_id) VALUES
(1, 101, 1),   -- Valid: addr_A owns utxo 1
(2, 102, 3),   -- Invalid: addr_A does NOT own utxo 3 (owned by addr_B)
(3, 103, 4),   -- Valid: addr_C owns utxo 4
(4, 104, 2),   -- Invalid: utxo 2 already used by txn 101 (double-spend)
(5, 105, 5);   -- Valid: addr_D owns utxo 5
```

---

#### Solution

```sql
-- postgresql
WITH cte1 AS (
    SELECT
        t.transaction_id,
        t.sender,
        u.utxo_id,
        u.address,
        COUNT(u.utxo_id) OVER (PARTITION BY u.utxo_id ORDER BY t.timestamp) AS cnt
    FROM transaction_inputs AS ti
    LEFT JOIN transactions AS t ON ti.transaction_id = t.transaction_id
    LEFT JOIN utxo AS u ON ti.utxo_id = u.utxo_id
)
SELECT
    transaction_id AS InvalidTransactionId
FROM cte1
WHERE address <> sender
   OR cnt <> 1;
```

---

#### Sample Output

| InvalidTransactionId |
|----------------------|
| 102                  |
| 104                  |