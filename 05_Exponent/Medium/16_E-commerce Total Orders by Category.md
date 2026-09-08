## E-commerce: Total Orders by Category

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Companies** | Amazon |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/e-commerce-iii |

---

#### Problem Statement

Amazon is a large e-commerce platform where customers can order various items ranging from electronics to clothing.

You're provided with two tables, `orders` and `items`, with the following columns:

`orders`: `order_id`, `customer_id`, `order_date`, `item_id`, `order_quantity`

`items`: `item_id`, `item_category`

Write a SQL query to find how many units were ordered in each category in the last 7 days, for each day of the week. Sort alphabetically by `item_category`.

Desired output example:

| item_category | order_date | total_units_ordered |
|---------------|------------|----------------------|
| Books         | 2023-09-26 | 4                    |
| Books         | 2023-09-28 | 5                    |
| Clothing      | 2023-09-27 | 7                    |
| Clothing      | 2023-09-30 | 3                    |
| Electronics   | 2023-09-25 | 2                    |

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
(1, 101, '2023-09-20', 1, 99),
(2, 101, '2023-09-25', 1, 2),
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
    TO_CHAR(o.order_date, 'YYYY-MM-DD') AS order_date,
    SUM(o.order_quantity) AS total_units_ordered
FROM items AS i
LEFT JOIN orders AS o
    ON i.item_id = o.item_id
WHERE o.order_date BETWEEN (SELECT MAX(order_date) FROM orders) - INTERVAL '6 days'
                        AND (SELECT MAX(order_date) FROM orders)
GROUP BY i.item_category, o.order_date
ORDER BY 1, 2;
```

---

#### Sample Output

| item_category | order_date | total_units_ordered |
|----------------|------------|----------------------|
| Books          | 2023-09-26 | 4                    |
| Books          | 2023-09-28 | 5                    |
| Clothing       | 2023-09-27 | 7                    |
| Clothing       | 2023-09-30 | 3                    |
| Electronics    | 2023-09-25 | 2                    |
