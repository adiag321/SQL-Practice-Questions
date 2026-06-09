## Most Recent Transaction

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Link** | https://www.tryexponent.com/practice/prepare/most-recent-transaction |

---

#### Problem Statement

Given an e-commerce database, write a query to fetch the `id`, `name`, and `stock` of the most recently purchased product(s). If multiple products share the same most recent transaction date, return all of them.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    stock INT
);

CREATE TABLE transactions (
    id INT PRIMARY KEY,
    product_id INT,
    date DATE
);

INSERT INTO products (id, name, stock) VALUES
(1, 'Laptop', 50),
(2, 'Phone', 120),
(3, 'Tablet', 75),
(4, 'Headphones', 200);

INSERT INTO transactions (id, product_id, date) VALUES
(1, 1, '2024-01-10'),
(2, 2, '2024-02-15'),
(3, 3, '2024-03-20'),
(4, 1, '2024-04-05'),
(5, 4, '2024-05-01'),
(6, 2, '2024-05-01');
```

---

#### Solution

```sql
WITH recent_prod AS (
    SELECT
        p.id,
        t.date,
        p.name,
        p.stock,
        DENSE_RANK() OVER (ORDER BY t.date DESC) AS rnk
    FROM transactions AS t
    JOIN products AS p ON t.product_id = p.id
)
SELECT DISTINCT
    id,
    name,
    stock
FROM recent_prod
WHERE rnk = 1;
```

---

#### Sample Output

| id | name       | stock |
|----|------------|-------|
| 2  | Phone      | 120   |
| 4  | Headphones | 200   |