## Top Customer by Orders

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/questions/3973 |

---

#### Problem Statement

Find the customer who has placed the largest number of orders in total. Return user_id, name, and orders.

---

#### Create & Insert Statements

The following data is illustrative and is included to make the query executable.

```sql
CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, sex TEXT);
CREATE TABLE transactions (id INTEGER PRIMARY KEY, user_id INTEGER, created_at TIMESTAMP, product_id INTEGER, quantity INTEGER);
INSERT INTO users VALUES (1, 'Ana', 'F'), (2, 'Bo', 'M');
INSERT INTO transactions VALUES (1, 1, '2024-01-01', 1, 1), (2, 1, '2024-01-02', 2, 1), (3, 2, '2024-01-03', 1, 1);
```

---

#### Solution

```sql
-- postgresql

SELECT t.user_id, u.name, COUNT(t.id) AS orders
FROM transactions AS t
JOIN users AS u ON t.user_id = u.id
GROUP BY t.user_id, u.name
ORDER BY orders DESC, t.user_id
LIMIT 1;
```

---

#### Sample Output

| user_id | name | orders |
|---------|------|--------|
| 1 | Ana | 2 |

