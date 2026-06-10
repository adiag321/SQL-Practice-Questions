## Fill Missing Client Data

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Data Cleaning |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/fill-missing-client-data |

---

#### Problem Statement

When inspecting a retailer's product catalogue you notice many rows have a missing `category` value. The first product of each category always has the correct category filled, and subsequent products in the same category have `NULL`. Write a query that returns the product catalogue with the missing `category` values filled based on the first product of each category group.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category   VARCHAR(255),
    name       VARCHAR(255)
);

INSERT INTO products (product_id, category, name) VALUES
(1, 'Electronics', 'Laptop'),
(2, NULL,         'Tablet'),
(3, NULL,         'Smartphone'),
(4, 'Clothing',   'T-Shirt'),
(5, NULL,         'Jeans'),
(6, NULL,         'Sneakers');
```

---

#### Solution

```sql
WITH grouped_products AS (
    SELECT product_id,
           category,
           name,
           COUNT(category) OVER (ORDER BY product_id) AS category_group
    FROM products
)
SELECT product_id,
       CASE WHEN category IS NULL THEN FIRST_VALUE(category) OVER (PARTITION BY category_group)
            ELSE category END AS category,
       name
FROM grouped_products;
```

---

#### Sample Output

| product_id | category   | name       |
|-----------|------------|------------|
| 1 | Electronics | Laptop |
| 2 | Electronics | Tablet |
| 3 | Electronics | Smartphone |
| 4 | Clothing    | T-Shirt |
| 5 | Clothing    | Jeans |
| 6 | Clothing    | Sneakers |
