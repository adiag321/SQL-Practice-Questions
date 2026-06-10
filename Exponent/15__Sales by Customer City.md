## Sales by Customer City

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/questions/3048/sales-by-city |

---

#### Problem Statement

Write a query to fetch the number of transactions per user city, ordered by descending number of transactions.

Your output should contain: `user_city`, `number_of_transactions`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS product_lines;
DROP TABLE IF EXISTS exchange_rate;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    user_city VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE product_lines (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    product_line_id INTEGER,
    stock INTEGER
);

CREATE TABLE transactions (
    id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    product_id INTEGER,
    amount INTEGER,
    currency_code VARCHAR(10),
    date DATE
);

CREATE TABLE exchange_rate (
    id INTEGER PRIMARY KEY,
    source_currency_code VARCHAR(10),
    target_currency_code VARCHAR(10),
    rate NUMERIC(10, 4)
);

INSERT INTO users (id, first_name, last_name, user_city, email) VALUES
(1, 'Alice',   'Smith',    'New York',    'alice@email.com'),
(2, 'Bob',     'Jones',    'Los Angeles', 'bob@email.com'),
(3, 'Carol',   'Williams', 'New York',    'carol@email.com'),
(4, 'David',   'Brown',    'Chicago',     'david@email.com'),
(5, 'Eve',     'Davis',    'Los Angeles', 'eve@email.com'),
(6, 'Frank',   'Miller',   'Houston',     'frank@email.com');

INSERT INTO product_lines (id, name) VALUES
(1, 'Electronics'),
(2, 'Clothing');

INSERT INTO products (id, name, product_line_id, stock) VALUES
(101, 'Laptop',  1, 50),
(102, 'T-Shirt', 2, 200);

INSERT INTO transactions (id, customer_id, product_id, amount, currency_code, date) VALUES
(1, 1, 101, 1200, 'USD', '2024-01-10'),
(2, 1, 102,   30, 'USD', '2024-02-14'),
(3, 2, 101, 1100, 'USD', '2024-01-22'),
(4, 3, 102,   25, 'USD', '2024-03-05'),
(5, 3, 101,  950, 'USD', '2024-03-18'),
(6, 3, 102,   40, 'USD', '2024-04-02'),
(7, 4, 101, 1050, 'USD', '2024-02-28'),
(8, 5, 102,   35, 'USD', '2024-01-30');
-- Frank (Houston) has no transactions → 0

INSERT INTO exchange_rate (id, source_currency_code, target_currency_code, rate) VALUES
(1, 'EUR', 'USD', 1.0850);
```

---

#### Solution

```sql
SELECT
    u.user_city,
    COUNT(t.id) AS number_of_transactions
FROM users AS u
LEFT JOIN transactions AS t ON u.id = t.customer_id
GROUP BY 1
ORDER BY 2 DESC;
```

---

#### Sample Output

| user_city   | number_of_transactions |
|-------------|------------------------|
| New York    | 3                      |
| Los Angeles | 2                      |
| Chicago     | 1                      |
| Houston     | 0                      |
