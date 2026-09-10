## Monthly Sales Report

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/courses/data-engineering/sql-interviews/monthly-sales-report |

---

#### Problem Statement

Using the sales tables, report the number of users, transactions, and total order amount per month for 2020. Then modify the query to report the same metrics by month-year for multiple years, ordered by descending month-year.

---

#### Create & Insert Statements

The following data is illustrative and is included to make the query executable.

```sql
CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT, price NUMERIC);
CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, sex TEXT);
CREATE TABLE transactions (id INTEGER PRIMARY KEY, user_id INTEGER, created_at TIMESTAMP, product_id INTEGER, quantity INTEGER);
INSERT INTO products VALUES (1, 'Notebook', 10), (2, 'Pen', 5);
INSERT INTO users VALUES (1, 'Ana', 'F'), (2, 'Bo', 'M');
INSERT INTO transactions VALUES (1, 1, '2020-03-01', 1, 2), (2, 2, '2021-03-03', 2, 4), (3, 1, '2021-11-04', 1, 1);
```

---

#### Solution

```sql
-- postgresql

SELECT TO_CHAR(t.created_at, 'YYYY-MM') AS month_year,
       COUNT(DISTINCT t.user_id) AS num_customers,
       COUNT(t.id) AS num_orders,
       SUM(p.price * t.quantity) AS order_amt
FROM transactions AS t
JOIN products AS p ON t.product_id = p.id
GROUP BY TO_CHAR(t.created_at, 'YYYY-MM')
ORDER BY month_year DESC;
```

---

#### Sample Output

| month_year | num_customers | num_orders | order_amt |
|-------------|---------------|------------|-----------|
| 2021-11 | 1 | 1 | 10 |
| 2021-03 | 1 | 1 | 20 |
| 2020-03 | 1 | 1 | 20 |

