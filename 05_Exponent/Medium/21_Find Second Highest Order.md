## Find Second Highest Order

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/find-second-highest-order |

---

#### Problem Statement

You are given orders (order_id, customer_id, order_date, order_amount, department_id), departments (department_id, department_name), and customers (customer_id, first_name, last_name). Find the second-highest distinct order amount in the Fashion department. Return order_amount.

---

#### Create & Insert Statements

The following data is illustrative and is included to make the query executable.

```sql
CREATE TABLE departments (department_id INTEGER PRIMARY KEY, department_name TEXT);
CREATE TABLE customers (customer_id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT);
CREATE TABLE orders (order_id INTEGER PRIMARY KEY, customer_id INTEGER, order_date DATE, order_amount NUMERIC, department_id INTEGER);
INSERT INTO departments VALUES (1, 'Fashion'), (2, 'Home');
INSERT INTO customers VALUES (1, 'Ana', 'Lee'), (2, 'Bo', 'Kim');
INSERT INTO orders VALUES (1, 1, '2024-01-01', 100, 1), (2, 2, '2024-01-02', 250, 1), (3, 1, '2024-01-03', 180, 1), (4, 2, '2024-01-04', 90, 2);
```

---

#### Solution

```sql
-- postgresql

WITH ranked_orders AS (
    SELECT o.order_amount,
           DENSE_RANK() OVER (ORDER BY o.order_amount DESC) AS amount_rank
    FROM orders AS o
    JOIN departments AS d ON o.department_id = d.department_id
    WHERE d.department_name = 'Fashion'
)
SELECT order_amount
FROM ranked_orders
WHERE amount_rank = 2;
```

---

#### Sample Output

| order_amount |
|---------------|
| 180 |

