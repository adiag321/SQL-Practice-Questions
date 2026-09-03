## Total Transaction Volume

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Companies** | Exponent |
| **Link** | https://www.tryexponent.com/practice/prepare/total-transaction-volume |

---

#### Problem Statement

Given the e-commerce database schema below, write a SQL query to fetch the total transaction value in dollars (USD) for the product line "Telephones" and return it as `total_amount_in_dollars`.

You will need to use the `exchange_rate` table.

Keep in mind that the `amount` field represents hundredths of the base currency.

Round up the result to two decimal points.

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
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    user_city INTEGER,
    email INTEGER
);

CREATE TABLE product_lines (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    product_line_id INTEGER,
    stock INTEGER,
    FOREIGN KEY (product_line_id) REFERENCES product_lines(id)
);

CREATE TABLE transactions (
    id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    product_id INTEGER,
    amount INTEGER,
    currency_code VARCHAR(10),
    date DATE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE exchange_rate (
    id INTEGER PRIMARY KEY,
    source_currency_code VARCHAR(10),
    target_currency_code VARCHAR(10),
    rate NUMERIC
);

-- Sample data
INSERT INTO users (id, first_name, last_name, user_city, email) VALUES
(1, 'John', 'Doe', 101, 1001),
(2, 'Jane', 'Smith', 102, 1002),
(3, 'Bob', 'Johnson', 103, 1003);

INSERT INTO product_lines (id, name) VALUES
(1, 'Telephones'),
(2, 'Laptops'),
(3, 'Accessories');

INSERT INTO products (id, name, product_line_id, stock) VALUES
(1, 'iPhone 15', 1, 50),
(2, 'Samsung Galaxy S24', 1, 30),
(3, 'Google Pixel 8', 1, 20),
(4, 'MacBook Pro', 2, 15),
(5, 'Dell XPS', 2, 25),
(6, 'Phone Case', 3, 100),
(7, 'Screen Protector', 3, 200);

INSERT INTO exchange_rate (id, source_currency_code, target_currency_code, rate) VALUES
(1, 'EUR', 'USD', 1.08),
(2, 'GBP', 'USD', 1.27),
(3, 'JPY', 'USD', 0.0067),
(4, 'USD', 'USD', 1.00);

INSERT INTO transactions (id, customer_id, product_id, amount, currency_code, date) VALUES
-- Telephones transactions in various currencies
(1, 1, 1, 85000, 'EUR', '2024-01-15'),   -- 850.00 EUR * 1.08 = 918.00 USD
(2, 2, 2, 60000, 'GBP', '2024-01-20'),   -- 600.00 GBP * 1.27 = 762.00 USD
(3, 3, 3, 4500000, 'JPY', '2024-02-01'), -- 45000.00 JPY * 0.0067 = 301.50 USD
(4, 1, 1, 120000, 'USD', '2024-02-10'),  -- 1200.00 USD * 1.00 = 1200.00 USD
(5, 2, 2, 95000, 'EUR', '2024-02-15');   -- 950.00 EUR * 1.08 = 1026.00 USD
```

---

#### Solution

```sql
-- postgresql
SELECT
    ROUND(SUM(t.amount / 100.0 * er.rate), 2) AS total_amount_in_dollars
FROM transactions AS t
JOIN products AS p ON t.product_id = p.id
JOIN product_lines AS pl ON p.product_line_id = pl.id
JOIN exchange_rate AS er ON t.currency_code = er.source_currency_code
WHERE pl.name = 'Telephones'
  AND er.target_currency_code = 'USD';
```

---

#### Sample Output

| total_amount_in_dollars |
|-------------------------|
| 924.64                  |