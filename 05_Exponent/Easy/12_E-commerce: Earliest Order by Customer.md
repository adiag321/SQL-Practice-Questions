## E-commerce: Earliest Order by Customer

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Companies** | Amazon |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/e-commerce-iv |

---

#### Problem Statement

Amazon is a large e-commerce platform where customers can order various items ranging from electronics to clothing.

You're provided with two tables, `orders` and `items`, with the following columns:

`orders`: `order_id`, `customer_id`, `order_date`, `item_id`, `order_quantity`

`items`: `item_id`, `item_category`

Write a SQL query to get the earliest `order_id` for each customer for each date they placed an order (they can place multiple orders per day). Your output should have the following columns: `customer_id`, `order_date`, `earliest_order_id`. Order in ascending order date. Within the same date, order by ascending customer ID.

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
(1, 101, '2023-09-01', 1, 2),
(2, 101, '2023-09-01', 2, 1),
(3, 101, '2023-09-02', 1, 4),
(4, 102, '2023-09-01', 3, 5),
(5, 102, '2023-09-01', 1, 3);
```

---

#### Solution

```sql
-- postgresql

SELECT
    customer_id,
    order_date,
    MIN(order_id) AS earliest_order_id
FROM orders
GROUP BY 1, 2
ORDER BY 2, 1;
```

---

#### Sample Output

| customer_id | order_date | earliest_order_id |
|--------------|-------------|----------------------|
| 101          | 2023-09-01  | 1                    |
| 102          | 2023-09-01  | 4                    |
| 101          | 2023-09-02  | 3                    |
