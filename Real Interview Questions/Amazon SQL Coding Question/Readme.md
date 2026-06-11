# Amazon Orders SQL Technical Assessment

This question about Amazon orders comes from a real Amazon Data Analyst SQL assessment. It’s a multi-part SQL question, similar to how take-home SQL challenges are structured, and asks increasingly more complex questions about the Amazon orders.

## Table Schema

### orders Table

| Column Name    | Type      |
|----------------|-----------|
| order_id       | varchar   |
| customer_id    | int       |
| order_datetime | timestamp |
| item_id        | varchar   |
| order_quantity | int       |

### items Table

| Column Name   | Type    |
|---------------|---------|
| item_id       | varchar |
| item_category | varchar |

## Schema Setup

```sql
CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_category VARCHAR(100)
);

INSERT INTO items (item_id, item_category) VALUES
('C004', 'Books'),
('C005', 'Books'),
('C006', 'Apparel'),
('C007', 'Electronics'),
('C008', 'Electronics');

CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id INT,
    order_datetime TIMESTAMP,
    item_id VARCHAR(50),
    order_quantity INT,
    PRIMARY KEY (order_id, item_id)
);

INSERT INTO orders (order_id, customer_id, order_datetime, item_id, order_quantity) VALUES
('O-001', 42489, '2023-06-15 04:35:22', 'C004', 3),
('O-005', 11733, '2023-01-12 11:48:35', 'C005', 1),
('O-005', 11733, '2023-01-12 11:48:35', 'C008', 1),
('O-006', 83167, '2023-01-16 02:52:07', 'C012', 2);
```

---

## Question 1: Yesterday's Units Ordered

### Problem Description

How many units were ordered yesterday?

*Hint: Yesterday’s date can be found via the PostgreSQL snippet:*
```sql
SELECT current_date - INTEGER '1' AS yesterday_date
```

### Solution

```sql
SELECT COALESCE(SUM(order_quantity), 0) AS total_units_ordered
FROM orders
WHERE CAST(order_datetime AS DATE) = CURRENT_DATE - 1;
```

### Expected Output

*Assumed `CURRENT_DATE` is `2023-06-16` (making yesterday `2023-06-15`):*

| total_units_ordered |
|---------------------|
| 3                   |

---

## Question 2: Units Ordered per Category in Last 7 Days

### Problem Description

In the last 7 days (including today), how many units were ordered in each category?
*Hint: You need to consider ALL categories, even those with zero orders!*

### Solution

```sql
SELECT
    i.item_category,
    COALESCE(SUM(o.order_quantity), 0) AS total_units_ordered
FROM items i
LEFT JOIN orders o ON i.item_id = o.item_id 
    AND CAST(o.order_datetime AS DATE) BETWEEN CURRENT_DATE - 6 AND CURRENT_DATE
GROUP BY i.item_category;
```

### Expected Output

*Assumed `CURRENT_DATE` is `2023-06-15` (date range: `2023-06-09` to `2023-06-15`):*

| item_category | total_units_ordered |
|---------------|---------------------|
| Apparel       | 0                   |
| Books         | 3                   |
| Electronics   | 0                   |

---

## Question 3: Earliest Order per Customer per Date

### Problem Description

Write a query to get the earliest `order_id` for all customers for each date they placed an order.
*Hint: Customers can place multiple orders on a single day!*

### Solution

```sql
WITH UniqueOrders AS (
    SELECT DISTINCT
        customer_id,
        CAST(order_datetime AS DATE) AS order_date,
        order_id,
        order_datetime
    FROM orders
),
RankedOrders AS (
    SELECT
        customer_id,
        order_date,
        order_id,
        ROW_NUMBER() OVER(PARTITION BY customer_id, order_date ORDER BY order_datetime ASC) AS rn
    FROM UniqueOrders
)
SELECT
    customer_id,
    order_date,
    order_id
FROM RankedOrders
WHERE rn = 1;
```

### Expected Output

| customer_id | order_date | order_id |
|-------------|------------|----------|
| 11733       | 2023-01-12 | O-005    |
| 83167       | 2023-01-16 | O-006    |
| 42489       | 2023-06-15 | O-001    |

---

## Question 4: Second Earliest Order for Multi-Order Dates

### Problem Description

Write a query to find the second earliest `order_id` for each customer for each date they placed two or more orders.

### Solution

```sql
WITH UniqueOrders AS (
    SELECT DISTINCT
        customer_id,
        CAST(order_datetime AS DATE) AS order_date,
        order_id,
        order_datetime
    FROM orders
),
RankedOrders AS (
    SELECT
        customer_id,
        order_date,
        order_id,
        ROW_NUMBER() OVER(PARTITION BY customer_id, order_date ORDER BY order_datetime ASC) AS rn,
        COUNT(*) OVER(PARTITION BY customer_id, order_date) AS total_orders_on_date
    FROM UniqueOrders
)
SELECT
    customer_id,
    order_date,
    order_id
FROM RankedOrders
WHERE total_orders_on_date >= 2 AND rn = 2;
```

### Expected Output

*(No rows returned for the provided sample data, as no customer has placed two or more distinct orders on the same day.)*

*Example: If customer `11733` had also placed order `O-007` on `2023-01-12 16:15:00`, the output would return:*

| customer_id | order_date | order_id |
|-------------|------------|----------|
| 11733       | 2023-01-12 | O-007    |
