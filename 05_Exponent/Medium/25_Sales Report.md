## Sales Report

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/questions/3971/sales-report |

---

#### Problem Statement

Report the number of users, number of transactions, and total order amount per month in 2020. Return month_name, num_customers, num_orders, and order_amt, ordered by descending month.

---

#### Create & Insert Statements

The following data is illustrative and is included to make the query executable.

```sql
CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT, price NUMERIC);
CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, sex TEXT);
CREATE TABLE transactions (id INTEGER PRIMARY KEY, user_id INTEGER, created_at TIMESTAMP, product_id INTEGER, quantity INTEGER);
INSERT INTO products VALUES (1, 'Notebook', 10), (2, 'Pen', 5);
INSERT INTO users VALUES (1, 'Ana', 'F'), (2, 'Bo', 'M');
INSERT INTO transactions VALUES (1, 1, '2020-03-01', 1, 2), (2, 2, '2020-03-03', 2, 4), (3, 1, '2020-11-04', 1, 1);
```

---

#### Solution

```sql
-- postgresql

SELECT EXTRACT(MONTH FROM t.created_at) AS month_name,
       COUNT(DISTINCT t.user_id) AS num_customers,
       COUNT(t.id) AS num_orders,
       SUM(t.quantity * p.price) AS order_amt
FROM transactions AS t
JOIN products AS p ON t.product_id = p.id
WHERE EXTRACT(YEAR FROM t.created_at) = 2020
GROUP BY EXTRACT(MONTH FROM t.created_at)
ORDER BY month_name DESC;
```

---

#### Sample Output

| month_name | num_customers | num_orders | order_amt |
|-------------|---------------|------------|-----------|
| 11 | 1 | 1 | 10 |
| 3 | 2 | 2 | 40 |

