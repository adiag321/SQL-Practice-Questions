## Pharmacy Analytics (Part 2)

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · ABS · WHERE · GROUP BY |
| **Companies** | CVS Health |
| **Link** | https://datalemur.com/questions/non-profitable-drugs |

---

#### Problem Statement

Given a table of pharmacy sales, write a query to identify all **manufacturers whose drugs are loss-making** (i.e., total_sales ≤ cogs). For each such manufacturer, output their name, number of loss-making drugs, and total loss amount. Order by total loss descending.

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
-- AstraZeneca: 2 loss-making drugs
(1, 100, 5000.00, 7000.00, 'DrugA', 'AstraZeneca'),  -- loss 2000
(2, 200, 3000.00, 4500.00, 'DrugB', 'AstraZeneca'),  -- loss 1500
-- Biogen: 1 loss-making drug
(3,  50, 1000.00, 1200.00, 'DrugC', 'Biogen'),        -- loss 200
-- Johnson: profitable → excluded
(4, 300, 9000.00, 3000.00, 'DrugD', 'Johnson');
```

---

#### Solution

```sql
SELECT manufacturer,
    COUNT(drug) AS drug_count,
    ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales <= cogs
GROUP BY manufacturer
ORDER BY total_loss DESC;
```

---

#### Sample Output

| manufacturer | drug_count | total_loss |
|--------------|------------|------------|
| AstraZeneca  | 2          | 3500.00    |
| Biogen       | 1          | 200.00     |
