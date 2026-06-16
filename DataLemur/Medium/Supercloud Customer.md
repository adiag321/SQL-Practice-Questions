## Supercloud Customer

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Aggregation |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/supercloud-customer |

---

#### Problem Statement

Identify customers who have purchased **every product category** available. Return the `customer_id` of such customers.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS customer_contracts;
DROP TABLE IF EXISTS products;

CREATE TABLE customer_contracts (
    customer_id INTEGER,
    product_id  INTEGER
);

CREATE TABLE products (
    product_id      INTEGER PRIMARY KEY,
    product_category VARCHAR(50)
);

INSERT INTO products (product_id, product_category) VALUES
(1, 'Analytics'),
(2, 'Storage'),
(3, 'AI'),
(4, 'Security');

-- Customer 101 has all categories
INSERT INTO customer_contracts (customer_id, product_id) VALUES
(101, 1), (101, 2), (101, 3), (101, 4),
-- Customer 102 is missing 'AI'
(102, 1), (102, 2), (102, 4),
-- Customer 103 has all categories as well
(103, 1), (103, 2), (103, 3), (103, 4);
```

---

#### Solution

```sql
WITH supercloud AS (
    SELECT cc.customer_id,
           COUNT(DISTINCT p.product_category) AS num_categories
    FROM customer_contracts cc
    JOIN products p ON cc.product_id = p.product_id
    GROUP BY cc.customer_id
)
SELECT customer_id
FROM supercloud
WHERE num_categories = (SELECT COUNT(DISTINCT product_category) FROM products);
```

---

#### Sample Output

| customer_id |
|------------|
| 101 |
| 103 |
