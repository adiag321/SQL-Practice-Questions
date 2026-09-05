## Amazon Order Status

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Companies** | Amazon |
| **Link** | https://www.tryexponent.com/courses/data-science/sql-interviews/amazon-order-status |

---

#### Problem Statement

Amazon is a global e-commerce company that allows vendors to sell their products online to customers. Customers can order products and track their orders' status, such as 'Pending', 'Shipped', 'Delivered', etc.

You're given a table, `orders`, with the following columns:

| Column | Description |
|--------|-------------|
| order_id (integer) | a unique identifier for each order |
| order_date (date) | the date the order status was updated |
| status (string) | the status of the order, e.g., 'Pending', 'Shipped', 'Delivered', etc. |

Write a SQL query that returns a table with the `order_id`, `status`, `start_date`, and `end_date` for each status period of a particular order. If a status is the first for that order, then the `end_date` should be NULL.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INTEGER,
    order_date DATE,
    status VARCHAR(50)
);

-- Sample data
-- Order 1: Pending -> Shipped -> Delivered (3 status periods)
-- Order 2: Pending -> Shipped (2 status periods; Shipped is ongoing = end_date NULL)
-- Order 3: Delivered (1 status period; end_date NULL)
INSERT INTO orders (order_id, order_date, status) VALUES
(1, '2024-01-01', 'Pending'),
(1, '2024-01-05', 'Shipped'),
(1, '2024-01-10', 'Delivered'),
(2, '2024-01-02', 'Pending'),
(2, '2024-01-07', 'Shipped'),
(3, '2024-01-03', 'Delivered');
```

---

#### Solution

```sql
-- postgresql
WITH StatusChanges AS (
    SELECT
        order_id,
        order_date,
        status,
        LAG(status) OVER (PARTITION BY order_id ORDER BY order_date) AS prev_status
    FROM orders
),
FilteredChanges AS (
    SELECT
        order_id,
        order_date,
        status
    FROM StatusChanges
    WHERE status != prev_status OR prev_status IS NULL
)
SELECT
    order_id,
    status,
    order_date AS start_date,
    LEAD(order_date) OVER (PARTITION BY order_id ORDER BY order_date) AS end_date
FROM FilteredChanges;
```

---

#### Sample Output

| order_id | status    | start_date | end_date   |
|----------|-----------|------------|------------|
| 1        | Pending   | 2024-01-01 | 2024-01-05 |
| 1        | Shipped   | 2024-01-05 | 2024-01-10 |
| 1        | Delivered | 2024-01-10 | NULL       |
| 2        | Pending   | 2024-01-02 | 2024-01-07 |
| 2        | Shipped   | 2024-01-07 | NULL       |
| 3        | Delivered | 2024-01-03 | NULL       |