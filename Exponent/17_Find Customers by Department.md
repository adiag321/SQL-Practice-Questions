## Find Customers by Department

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/practice/prepare/find-customers-by-department |

---

#### Problem Statement

Find how many customers ordered from the electronics and the fashion department respectively in 2022. Your output should have the following columns: `customers`, `department_name`.

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
(2, 'Fashion'),
(3, 'Groceries');

INSERT INTO customers (customer_id, first_name, last_name) VALUES
(101, 'Alice', 'Smith'),
(102, 'Bob', 'Jones'),
(103, 'Carol', 'Williams');

INSERT INTO orders (order_id, customer_id, order_date, order_amount, department_id) VALUES
(1, 101, '2022-01-15', 150, 1),
(2, 102, '2022-06-20', 200, 1),
(3, 102, '2022-07-11', 50,  2),
(4, 103, '2022-08-05', 80,  2),
(5, 101, '2023-01-10', 300, 1);
```

---

#### Solution

```sql
SELECT
    COUNT(DISTINCT customer_id) AS customers,
    d.department_name
FROM orders AS o
JOIN departments AS d ON o.department_id = d.department_id
WHERE d.department_name IN ('Electronics', 'Fashion')
    AND EXTRACT(YEAR FROM o.order_date) = 2022
GROUP BY 2;
```

---

#### Sample Output

| customers | department_name |
|-----------|-----------------|
| 2         | Electronics     |
| 2         | Fashion |