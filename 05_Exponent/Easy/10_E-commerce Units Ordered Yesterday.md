## E-commerce: Units Ordered Yesterday

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Companies** | Amazon |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/e-commerce-i |

---

#### Problem Statement

Amazon is a large e-commerce platform where customers can order various items ranging from electronics to clothing.

You're provided with two tables, `orders` and `items`, with the following columns:

`orders`: `order_id`, `customer_id`, `order_date`, `item_id`, `order_quantity`

`items`: `item_id`, `item_category`

Write a SQL query that determines how many units were ordered on Amazon yesterday. Output it under the column `total_units_ordered_yesterday`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS items;

CREATE TABLE items (
    item_id INTEGER PRIMARY KEY,
    item_category VARCHAR(50)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    item_id INTEGER,
    order_quantity INTEGER
);

INSERT INTO items (item_id, item_category) VALUES
(1, 'Electronics'),
(2, 'Books');

INSERT INTO orders (order_id, customer_id, order_date, item_id, order_quantity) VALUES
(1, 101, '2023-10-03', 1, 5),
(2, 101, '2023-10-04', 1, 7),
(3, 102, '2023-10-04', 2, 3),
(4, 102, '2023-10-05', 2, 10);
```

---

#### Solution

```sql
-- postgresql
SELECT
    SUM(order_quantity) AS total_units_ordered_yesterday
FROM orders
WHERE order_date = (SELECT MAX(order_date) FROM orders) - INTERVAL '1 day';
```

---

#### Sample Output

| total_units_ordered_yesterday |
|----------------------------------|
| 10                                |
