# Amazon BIE SQL Question

## Table Schema

### order_product Table

| Column Name | Type         |
|-------------|--------------|
| order_id    | int          |
| product_id  | varchar(255) |
| quantity    | int          |

### shipment_order Table

| Column Name | Type          |
|-------------|---------------|
| shipment_id | int           |
| order_id    | int           |
| cost        | numeric(28,10)|

## Schema Setup

```sql
CREATE TABLE order_product (
    order_id INT,
    product_id VARCHAR(255),
    quantity INT
);

INSERT INTO order_product (order_id, product_id, quantity) VALUES
(1, 'a', 2),
(1, 'b', 4),
(2, 'b', 2),
(3, 'c', 5),
(3, 'a', 3),
(4, 'd', 10);

CREATE TABLE shipment_order (
    shipment_id INT,
    order_id INT,
    cost NUMERIC(28, 10)
);

INSERT INTO shipment_order (shipment_id, order_id, cost) VALUES
(1, 1, 1.22),
(2, 4, 3.55),
(3, 3, 5.91),
(4, 2, 2.44);
```

---

## Question 1: Pivot Product Quantities

### Problem Description

Write a query that returns a single row for each `order_id` with a column for the quantity of product 'a', one with the quantity of product 'b', and one with the quantity for all other products.

### Solution

```sql
SELECT
    order_id,
    SUM(CASE WHEN product_id = 'a' THEN quantity ELSE 0 END) AS product_a,
    SUM(CASE WHEN product_id = 'b' THEN quantity ELSE 0 END) AS product_b,
    SUM(CASE WHEN product_id NOT IN ('a', 'b') THEN quantity ELSE 0 END) AS product_others
FROM order_product
GROUP BY order_id;
```

### Expected Output

| order_id | product_a | product_b | product_others |
|----------|-----------|-----------|----------------|
| 1        | 2         | 4         | 0              |
| 2        | 0         | 2         | 0              |
| 3        | 3         | 0         | 5              |
| 4        | 0         | 0         | 10             |

---

## Question 2: Cost Per Unit

### Problem Description

Write a SQL query that calculates the cost per unit to complete each order and limit the result of the query to only top two orders with highest cost per unit.

### Solution

```sql
SELECT
    o.order_id,
    ROUND(s.cost / SUM(o.quantity), 2) AS cost_per_unit
FROM order_product AS o
JOIN shipment_order AS s ON o.order_id = s.order_id
GROUP BY o.order_id, s.cost
ORDER BY cost_per_unit DESC
LIMIT 2;
```

### Expected Output

| order_id | cost_per_unit |
|----------|---------------|
| 2        | 1.22          |
| 3        | 0.74          |

---

## Question 3: Percent Contribution

### Problem Description

Write a SQL query that returns each order, `product_id`, `quantity`, and its percent contribution to the total order quantity.

### Solution

```sql
SELECT
    op.order_id,
    op.product_id,
    op.quantity,
    (op.quantity / total.total_quantity) AS contribution_pct
FROM order_product op
JOIN (
    SELECT
        order_id,
        SUM(quantity) AS total_quantity
    FROM order_product
    GROUP BY order_id
) total ON op.order_id = total.order_id;
```

### Expected Output

| order_id | product_id | quantity | contribution_pct |
|----------|------------|----------|------------------|
| 1        | a          | 2        | 0.3333           |
| 1        | b          | 4        | 0.6667           |
| 2        | b          | 2        | 1.0000           |
| 3        | c          | 5        | 0.6250           |
| 3        | a          | 3        | 0.3750           |
| 4        | d          | 10       | 1.0000           |
