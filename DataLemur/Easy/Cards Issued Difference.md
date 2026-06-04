## Cards Issued Difference

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · GROUP BY · ORDER BY |
| **Companies** | JPMorgan Chase |
| **Link** | https://datalemur.com/questions/cards-issued-difference |

---

#### Problem Statement

Given a table of monthly card issuances, write a query to find the **difference between the maximum and minimum** number of cards issued for each card name. Order the results by the difference in descending order.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS monthly_cards_issued;

CREATE TABLE monthly_cards_issued (
    issue_month INTEGER,
    issue_year  INTEGER,
    card_name   VARCHAR(100),
    issued_amount INTEGER
);

INSERT INTO monthly_cards_issued (issue_month, issue_year, card_name, issued_amount) VALUES
(1,  2021, 'Chase Sapphire Reserve', 170000),
(2,  2021, 'Chase Sapphire Reserve', 175000),
(3,  2021, 'Chase Sapphire Reserve', 180000),
(1,  2021, 'Chase Freedom Flex',      55000),
(2,  2021, 'Chase Freedom Flex',      60000),
(3,  2021, 'Chase Freedom Flex',      65000);
-- Chase Sapphire Reserve: 180000 - 170000 = 10000
-- Chase Freedom Flex:      65000 -  55000 = 10000
```

---

#### Solution

```sql
SELECT card_name, MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;
```

---

#### Sample Output

| card_name                 | difference |
|---------------------------|------------|
| Chase Sapphire Reserve    | 10000      |
| Chase Freedom Flex        | 10000      |
