## E-commerce: Units Ordered Last Week

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Companies** | Amazon |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/e-commerce-ii |

---

#### Problem Statement

Amazon is a large e-commerce platform where customers can order various items ranging from electronics to clothing.

You're provided with two tables, `orders` and `items`, with the following columns:

`orders`: `order_id`, `customer_id`, `order_date`, `item_id`, `order_quantity`

`items`: `item_id`, `item_category`

Write an SQL query that determines how many units were ordered from Amazon's e-commerce platform in the last week. Your output should have the following columns: `item_category`, `total_units_ordered_last_7_days`.

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
(2, 'Books'),
(3, 'Clothing');

INSERT INTO orders (order_id, customer_id, order_date, item_id, order_quantity) VALUES
(1, 101, '2023-09-20', 1, 50),
(2, 101, '2023-09-25', 1, 10),
(3, 102, '2023-09-26', 2, 4),
(4, 102, '2023-09-27', 3, 7),
(5, 103, '2023-09-28', 2, 5),
(6, 103, '2023-09-30', 3, 3);
```

---

#### Solution

```sql
-- postgresql
SELECT
    i.item_category,
    SUM(o.order_quantity) AS total_units_ordered_last_7_days
FROM orders AS o
JOIN items AS i
    ON o.item_id = i.item_id
WHERE o.order_date BETWEEN (SELECT MAX(order_date) FROM orders) - INTERVAL '6 days'
                        AND (SELECT MAX(order_date) FROM orders)
GROUP BY 1
ORDER BY 1;
```

---

#### Sample Output

| item_category | total_units_ordered_last_7_days |
|-----------------|-----------------------------------|
| Books           | 9                                  |
| Clothing        | 10                                 |
| Electronics     | 10                                 |
