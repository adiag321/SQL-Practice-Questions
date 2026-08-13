## Find Top Customer by Year

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Link** | https://www.tryexponent.com/questions/3977/find-top-customer-by-year |

---

#### Problem Statement

For each of the last 5 years, identify the customer who placed the most orders. Your output should have the following columns: `year`, `customer_id`, `first_name`, `last_name`, `total_orders`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    order_amount INTEGER,
    department_id INTEGER
);

INSERT INTO departments (department_id, department_name) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Groceries');

INSERT INTO customers (customer_id, first_name, last_name) VALUES
(101, 'Alice', 'Smith'),
(102, 'Bob', 'Jones'),
(103, 'Carol', 'Williams'),
(104, 'David', 'Brown'),
(105, 'Eve', 'Davis');

INSERT INTO orders (order_id, customer_id, order_date, order_amount, department_id) VALUES
-- 2019: Alice leads with 3 orders
(1,  101, '2019-02-10', 200, 1),
(2,  101, '2019-05-15', 150, 2),
(3,  101, '2019-09-20', 300, 3),
(4,  102, '2019-03-01', 100, 1),
(5,  102, '2019-07-22', 120, 2),
-- 2020: Bob leads with 3 orders
(6,  102, '2020-01-10', 250, 1),
(7,  102, '2020-04-18', 180, 3),
(8,  102, '2020-08-05', 220, 2),
(9,  103, '2020-06-12', 90,  1),
(10, 103, '2020-11-30', 110, 3),
-- 2021: Carol leads with 4 orders
(11, 103, '2021-01-05', 130, 2),
(12, 103, '2021-03-14', 160, 1),
(13, 103, '2021-07-22', 200, 3),
(14, 103, '2021-10-08', 140, 2),
(15, 104, '2021-05-19', 80,  1),
-- 2022: David leads with 3 orders
(16, 104, '2022-02-28', 175, 3),
(17, 104, '2022-06-10', 195, 1),
(18, 104, '2022-09-25', 210, 2),
(19, 105, '2022-04-03', 95,  3),
-- 2023: Eve leads with 3 orders
(20, 105, '2023-01-17', 305, 1),
(21, 105, '2023-05-30', 260, 2),
(22, 105, '2023-10-11', 185, 3),
(23, 101, '2023-08-22', 120, 1);
```

---

#### Solution

```sql
WITH orders_per_year AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date) AS year,
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(order_id) AS total_orders,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM o.order_date)
            ORDER BY COUNT(DISTINCT order_id) DESC
        ) AS rnk
    FROM orders AS o
    JOIN customers AS c ON o.customer_id = c.customer_id
    WHERE EXTRACT(YEAR FROM o.order_date) IN (2019, 2020, 2021, 2022, 2023)
    GROUP BY 1, 2, 3, 4
)
SELECT
    year,
    customer_id,
    first_name,
    last_name,
    total_orders
FROM orders_per_year
WHERE rnk = 1
ORDER BY year ASC;
```

---

#### Sample Output

| year | customer_id | first_name | last_name | total_orders |
|------|-------------|------------|-----------|--------------|
| 2019 | 101         | Alice      | Smith     | 3            |
| 2020 | 102         | Bob        | Jones     | 3            |
| 2021 | 103         | Carol      | Williams  | 4            |
| 2022 | 104         | David      | Brown     | 3            |
| 2023 | 105         | Eve        | Davis     | 3            |