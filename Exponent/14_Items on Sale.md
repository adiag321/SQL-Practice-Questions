## Items on Sale

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Companies** | Target |
| **Link** | https://www.tryexponent.com/questions/3073/items-on-sale |

---

#### Problem Statement

Target provides discounts on certain types of items as part of its marketing strategy. The discounting rules are:

- **Electronic** items are discounted by 10%
- **Clothing** items receive a 20% discount
- **Grocery** items are cheaper by 5%
- **Book** items come with a 15% discount

Write a SQL query to generate a discounted product catalog displaying `name`, `type`, and `discounted_price` for each item. Round the discounted price to the nearest cent.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    type VARCHAR(20),
    price DECIMAL(10, 2)
);

INSERT INTO products (id, name, type, price) VALUES
(1, 'Laptop Pro',       'Electronic', 1200.00),
(2, 'Winter Jacket',    'Clothing',    89.99),
(3, 'Organic Apples',   'Grocery',      4.50),
(4, 'SQL for Beginners','Book',        29.95),
(5, 'Bluetooth Speaker','Electronic',  59.99),
(6, 'Yoga Pants',       'Clothing',    45.00),
(7, 'Whole Milk',       'Grocery',      3.20),
(8, 'Mystery Novel',    'Book',        14.99);
```

---

#### Solution

```sql
SELECT
    name,
    type,
    CASE
        WHEN type = 'Electronic' THEN ROUND(price * 0.90, 2)
        WHEN type = 'Clothing'   THEN ROUND(price * 0.80, 2)
        WHEN type = 'Grocery'    THEN ROUND(price * 0.95, 2)
        WHEN type = 'Book'       THEN ROUND(price * 0.85, 2)
        ELSE price
    END AS discounted_price
FROM products;
```

---

#### Sample Output

| name                | type        | discounted_price |
|---------------------|-------------|------------------|
| Laptop Pro          | Electronic  | 1080.00          |
| Winter Jacket       | Clothing    | 71.99            |
| Organic Apples      | Grocery     | 4.27             |
| SQL for Beginners   | Book        | 25.46            |
| Bluetooth Speaker   | Electronic  | 53.99            |
| Yoga Pants          | Clothing    | 36.00            |
| Whole Milk          | Grocery     | 3.04             |
| Mystery Novel       | Book        | 12.74            |