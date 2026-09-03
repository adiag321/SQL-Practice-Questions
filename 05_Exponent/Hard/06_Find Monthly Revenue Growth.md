## Find Monthly Revenue Growth

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Companies** | Exponent |
| **Link** | https://www.tryexponent.com/practice/prepare/find-monthly-revenue-growth |

---

#### Problem Statement

You are given the following tables:

**orders table:**

| order_id | customer_id | order_date | order_amount | department_id |
|----------|-------------|------------|--------------|---------------|
| integer  | integer     | date       | integer      | integer       |

**departments table:**

| department_id | department_name |
|---------------|-----------------|
| integer       | string          |

**customers table:**

| customer_id | first_name | last_name |
|-------------|------------|-----------|
| integer     | string     | string    |

Find the department with the highest month-on-month increase (order amount) in December 2022. Your output should have the following columns: `department_id`, `department_name`, `mom_increase`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS customers;

CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    order_amount INTEGER,
    department_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Sample data
INSERT INTO departments (department_id, department_name) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Groceries');

INSERT INTO customers (customer_id, first_name, last_name) VALUES
(1, 'Alice', 'Smith'),
(2, 'Bob', 'Jones'),
(3, 'Carol', 'Williams'),
(4, 'David', 'Brown'),
(5, 'Eve', 'Davis');

INSERT INTO orders (order_id, customer_id, order_date, order_amount, department_id) VALUES
-- November 2022 orders
-- Electronics (dept 1): total = 10000
(1, 1, '2022-11-05', 3000, 1),
(2, 2, '2022-11-12', 4000, 1),
(3, 3, '2022-11-20', 3000, 1),
-- Clothing (dept 2): total = 8000
(4, 1, '2022-11-08', 3000, 2),
(5, 4, '2022-11-15', 5000, 2),
-- Groceries (dept 3): total = 5000
(6, 2, '2022-11-10', 2000, 3),
(7, 5, '2022-11-25', 3000, 3),

-- December 2022 orders
-- Electronics (dept 1): total = 15000 (increase = 5000)
(8, 1, '2022-12-03', 5000, 1),
(9, 3, '2022-12-10', 6000, 1),
(10, 4, '2022-12-18', 4000, 1),
-- Clothing (dept 2): total = 12000 (increase = 4000)
(11, 2, '2022-12-05', 7000, 2),
(12, 5, '2022-12-20', 5000, 2),
-- Groceries (dept 3): total = 9000 (increase = 4000)
(13, 1, '2022-12-08', 4000, 3),
(14, 3, '2022-12-22', 5000, 3);
```

---

#### Solution

```sql
-- postgresql
WITH nov_dec_order_amounts AS (
    SELECT
        department_id,
        SUM(order_amount) AS order_amount_per_month,
        to_char(order_date, 'YYYY-MM') AS y_m_date
    FROM orders
    WHERE to_char(order_date, 'YYYY-MM') IN ('2022-11', '2022-12')
    GROUP BY department_id, to_char(order_date, 'YYYY-MM')
),
mom_totals AS (
    SELECT
        department_id,
        y_m_date,
        (order_amount_per_month - LAG(order_amount_per_month) OVER (PARTITION BY department_id ORDER BY y_m_date)) AS mom_increase
    FROM nov_dec_order_amounts
)
SELECT
    d.department_id,
    d.department_name,
    m.mom_increase
FROM mom_totals m
JOIN departments d ON m.department_id = d.department_id
WHERE m.y_m_date = '2022-12'
  AND m.mom_increase = (
      SELECT MAX(mom_increase) FROM mom_totals WHERE y_m_date = '2022-12'
  )
ORDER BY d.department_id;
```

---

#### Sample Output

| department_id | department_name | mom_increase |
|---------------|-----------------|--------------|
| 1             | Electronics     | 5000         |