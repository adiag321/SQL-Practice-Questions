## Card Launch Success

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Ranking |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/card-launch-success |

---

#### Problem Statement

For each `card_name`, find the month and year when the card was issued with the highest `issued_amount`. Return `card_name` and `issued_amount` sorted by `issued_amount` descending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS monthly_cards_issued;

CREATE TABLE monthly_cards_issued (
    card_name   VARCHAR(50),
    issue_year  INTEGER,
    issue_month INTEGER,
    issued_amount INTEGER
);

INSERT INTO monthly_cards_issued (card_name, issue_year, issue_month, issued_amount) VALUES
('Platinum', 2022, 1, 5000),
('Platinum', 2022, 2, 7500),
('Gold',     2022, 1, 3000),
('Gold',     2022, 2, 2000),
('Silver',   2022, 1, 1500),
('Silver',   2022, 2, 1800);
```

---

#### Solution

```sql
SELECT card_name,
       issued_amount
FROM (
    SELECT card_name,
           issued_amount,
           DENSE_RANK() OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) AS rnk
    FROM monthly_cards_issued
) t
WHERE rnk = 1
ORDER BY issued_amount DESC;
```

---

#### Sample Output

| card_name | issued_amount |
|-----------|---------------|
| Platinum  | 7500 |
| Silver    | 1800 |
| Gold      | 3000 |
