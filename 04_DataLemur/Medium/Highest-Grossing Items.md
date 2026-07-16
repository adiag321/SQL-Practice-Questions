## Highest-Grossing Items

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Aggregation |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/highest-grossing-items |

---

#### Problem Statement

For each `category`, return the top two `product` items with the highest total spend in the year 2022. Output `category`, `product`, and `total_spend` ordered by `category` then `total_spend` descending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS product_spend;

CREATE TABLE product_spend (
    category         VARCHAR(50),
    product          VARCHAR(50),
    spend            DECIMAL(10,2),
    transaction_date DATE
);

INSERT INTO product_spend (category, product, spend, transaction_date) VALUES
('Electronics', 'Phone',   5000, '2022-01-15'),
('Electronics', 'Tablet',  3000, '2022-02-10'),
('Electronics', 'Laptop',  8000, '2022-03-05'),
('Electronics', 'Headset', 2000, '2022-04-12'),
('Furniture',   'Desk',    4000, '2022-01-20'),
('Furniture',   'Chair',   2500, '2022-02-18'),
('Furniture',   'Couch',   6000, '2022-03-22'),
('Furniture',   'Shelf',   1500, '2022-04-30');
```

---

#### Solution

```sql
WITH ct AS (
    SELECT category,
           product,
           SUM(spend) AS total_spend,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS rn
    FROM product_spend
    WHERE DATE_PART('year', transaction_date) = 2022
    GROUP BY category, product
)
SELECT category,
       product,
       total_spend
FROM ct
WHERE rn IN (1, 2)
ORDER BY category, total_spend DESC;
```

---

#### Sample Output

| category    | product | total_spend |
|------------|---------|------------|
| Electronics| Laptop  | 8000 |
| Electronics| Phone   | 5000 |
| Furniture  | Couch   | 6000 |
| Furniture  | Desk    | 4000 |
