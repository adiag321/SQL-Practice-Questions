## Pharmacy Analytics (Part 1)

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Arithmetic · ORDER BY · LIMIT |
| **Companies** | CVS Health |
| **Link** | https://datalemur.com/questions/top-profitable-drugs |

---

#### Problem Statement

Given a table of pharmacy sales, write a query to find the **top 3 most profitable drugs**. Output `drug` and `total_profit` (`total_sales - cogs`), ordered by profit descending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS pharmacy_sales;

CREATE TABLE pharmacy_sales (
    product_id   INTEGER,
    units_sold   INTEGER,
    total_sales  DECIMAL(10, 2),
    cogs         DECIMAL(10, 2),
    drug         VARCHAR(100),
    manufacturer VARCHAR(100)
);

INSERT INTO pharmacy_sales (product_id, units_sold, total_sales, cogs, drug, manufacturer) VALUES
(1,  55, 3996.00,  3478.00, 'Naloxone',   'Johnson'),
(2, 179, 6959.00,  3011.00, 'Epinephrin', 'Johnson'),
(3, 133, 3505.00,  3823.00, 'Nifedipine', 'AZ'),      -- loss-making
(4, 327, 9255.00,  1337.00, 'Robitussin', 'AZ'),
(5,  50, 2007.00,  1777.00, 'Morphine',   'Biogen');
-- profits: Naloxone=518, Epinephrin=3948, Robitussin=7918, Morphine=230
```

---

#### Solution

```sql
SELECT drug, (total_sales - cogs) AS total_profit
FROM pharmacy_sales
ORDER BY total_profit DESC
LIMIT 3;
```

---

#### Sample Output

| drug        | total_profit |
|-------------|--------------|
| Robitussin  | 7918.00      |
| Epinephrin  | 3948.00      |
| Naloxone    | 518.00       |
