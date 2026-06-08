## Pharmacy Analytics (Part 3)

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · Subquery · CONCAT · ROUND |
| **Companies** | CVS Health |
| **Link** | https://datalemur.com/questions/total-drugs-sales |

---

#### Problem Statement

Given a table of pharmacy sales, write a query to find the **total sales per manufacturer**, formatted as `$X million` rounded to the nearest million, ordered by total sales descending, then manufacturer alphabetically.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS pharmacy_sales;

CREATE TABLE pharmacy_sales (
    product_id   INTEGER,
    units_sold   INTEGER,
    total_sales  DECIMAL(12, 2),
    cogs         DECIMAL(12, 2),
    drug         VARCHAR(100),
    manufacturer VARCHAR(100)
);

INSERT INTO pharmacy_sales (product_id, units_sold, total_sales, cogs, drug, manufacturer) VALUES
(1, 2000,  3500000.00, 2100000.00, 'Aspirin',   'Johnson'),
(2, 1500,  1800000.00,  900000.00, 'Tylenol',   'Johnson'),
(3,  800,  4200000.00, 2500000.00, 'Metformin', 'Pfizer'),
(4,  300,   600000.00,  400000.00, 'Ibuprofen', 'AstraZeneca');
-- Johnson total = 5300000 → $5 million
-- Pfizer total  = 4200000 → $4 million
-- AstraZeneca   =  600000 → $1 million
```

---

#### Solution

```sql
SELECT manufacturer,
    CONCAT('$', total_result, ' million') AS sale
FROM (
    SELECT manufacturer, ROUND(SUM(total_sales) / 1000000) AS total_result
    FROM pharmacy_sales
    GROUP BY manufacturer
    ORDER BY SUM(total_sales) DESC, manufacturer
) AS TP;
```

---

#### Sample Output

| manufacturer | sale       |
|--------------|------------|
| Johnson      | $5 million |
| Pfizer       | $4 million |
| AstraZeneca  | $1 million |
