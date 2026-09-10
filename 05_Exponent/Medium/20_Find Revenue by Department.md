## Find Revenue by Department

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/find-revenue-by-department |

---

#### Problem Statement

You are given orders (order_id, customer_id, order_date, order_amount, department_id), departments (department_id, department_name), and customers (customer_id, first_name, last_name). Order departments from highest to lowest revenue in the last 12 months. Return department_name and total_revenue.

---

#### Create & Insert Statements

The following data is illustrative and is included to make the query executable.

```sql
CREATE TABLE departments (department_id INTEGER PRIMARY KEY, department_name TEXT);
CREATE TABLE customers (customer_id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT);
CREATE TABLE orders (order_id INTEGER PRIMARY KEY, customer_id INTEGER, order_date DATE, order_amount NUMERIC, department_id INTEGER);

INSERT INTO departments VALUES (1, 'Fashion'), (2, 'Home');
INSERT INTO customers VALUES (1, 'Ana', 'Lee'), (2, 'Bo', 'Kim');
INSERT INTO orders VALUES (1, 1, CURRENT_DATE - INTERVAL '2 months', 120, 1), (2, 2, CURRENT_DATE - INTERVAL '1 month', 80, 2), (3, 1, CURRENT_DATE - INTERVAL '1 month', 30, 1);
```

---

#### Solution

```sql
-- postgresql

SELECT d.department_name, SUM(o.order_amount) AS total_revenue
FROM orders AS o
JOIN departments AS d ON o.department_id = d.department_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY d.department_name
ORDER BY total_revenue DESC;
```

---

#### Sample Output

| department_name | total_revenue |
|-----------------|----------------|
| Fashion | 150 |
| Home | 80 |

