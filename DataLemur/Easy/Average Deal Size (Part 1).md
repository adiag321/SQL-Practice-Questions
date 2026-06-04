## Average Deal Size (Part 1)

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · ROUND · CAST |
| **Companies** | Salesforce |
| **Link** | https://datalemur.com/questions/sql-average-deal-size |

---

#### Problem Statement

Given a table of contracts, write a query to calculate the **average deal size** across all contracts. The deal size per contract is `yearly_seat_cost × num_seats`. Round the result to 2 decimal places.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS contracts;

CREATE TABLE contracts (
    contract_id      INTEGER,
    yearly_seat_cost DECIMAL(10, 2),
    num_seats        INTEGER
);

INSERT INTO contracts (contract_id, yearly_seat_cost, num_seats) VALUES
(1, 500.00,  10),   -- deal = 5000
(2, 300.00,  20),   -- deal = 6000
(3, 1000.00,  5),   -- deal = 5000
(4, 200.00,  50);   -- deal = 10000
-- avg deal = (5000 + 6000 + 5000 + 10000) / 4 = 6500.00
```

---

#### Solution

```sql
SELECT ROUND(SUM(yearly_seat_cost * num_seats) / COUNT(*)::DECIMAL, 2)
FROM contracts;
```

---

#### Sample Output

| round   |
|---------|
| 6500.00 |
