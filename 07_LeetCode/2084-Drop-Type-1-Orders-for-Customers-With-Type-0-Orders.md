# 2084. Drop Type 1 Orders for Customers With Type 0 Orders

## Problem Description

Write a solution to report all the orders based on the following criteria:

- If a customer has **at least one** order of type `0`, do **not** report any order of type `1` from that customer.
- Otherwise, report all orders of the customer.

Return the result table in any order.

Link: https://leetcode.com/problems/drop-type-1-orders-for-customers-with-type-0-orders/

## Table Schema

### Orders Table

| Column Name   | Type |
|---------------|------|
| order_id      | int  |
| customer_id   | int  |
| order_type    | int  |

- `order_id` is the primary key (column with unique values) of this table.
- Each row indicates the ID of an order, the ID of the customer who placed the order, and the order type.
- `order_type` is either `0` or `1`.

## Schema Setup

```sql
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_type INT
);

INSERT INTO Orders (order_id, customer_id, order_type)
VALUES
    (1, 1, 0),
    (2, 1, 0),
    (11, 2, 0),
    (12, 2, 1),
    (21, 3, 1),
    (22, 3, 1),
    (31, 4, 1),
    (32, 4, 0),
    (41, 5, 1);
```

## Example

### Input

**Orders Table:**

| order_id | customer_id | order_type |
|----------|-------------|------------|
| 1        | 1           | 0          |
| 2        | 1           | 0          |
| 11       | 2           | 0          |
| 12       | 2           | 1          |
| 21       | 3           | 1          |
| 22       | 3           | 1          |
| 31       | 4           | 1          |
| 32       | 4           | 0          |
| 41       | 5           | 1          |

### Output

| order_id | customer_id | order_type |
|----------|-------------|------------|
| 1        | 1           | 0          |
| 2        | 1           | 0          |
| 11       | 2           | 0          |
| 21       | 3           | 1          |
| 22       | 3           | 1          |
| 32       | 4           | 0          |
| 41       | 5           | 1          |

### Explanation

- **Customer 1**: Has two type 0 orders (1, 2) and no type 1 orders. Both type 0 orders are reported.
- **Customer 2**: Has one type 0 order (11) and one type 1 order (12). Only the type 0 order is reported because the customer has at least one type 0 order.
- **Customer 3**: Has only type 1 orders (21, 22) and no type 0 orders. Both type 1 orders are reported.
- **Customer 4**: Has one type 1 order (31) and one type 0 order (32). Only the type 0 order is reported because the customer has at least one type 0 order.
- **Customer 5**: Has only one type 1 order (41) and no type 0 orders. The type 1 order is reported.

## Solution

```sql
SELECT order_id, customer_id, order_type
FROM Orders
WHERE order_type = 0
   OR customer_id NOT IN (
       SELECT DISTINCT customer_id
       FROM Orders
       WHERE order_type = 0
   );
```

## Approach

The logic splits into two cases:

1. **Always keep type 0 orders** — they are always valid regardless.
2. **Keep type 1 orders only if the customer has no type 0 orders** — use a subquery to find all `customer_id`s that have at least one `order_type = 0`, and exclude type 1 orders for those customers.

**Key points:**
- The subquery `SELECT DISTINCT customer_id FROM Orders WHERE order_type = 0` identifies customers who have placed at least one type 0 order.
- `NOT IN` ensures that type 1 orders for those customers are dropped.
- Type 0 orders pass through directly via the `order_type = 0` condition in the `WHERE` clause.

## Complexity

- **Time Complexity**: O(n²) in the worst case due to the `NOT IN` subquery, but typically optimized by the database engine using a hash or index lookup.
- **Space Complexity**: O(k) where k is the number of distinct customers with type 0 orders.
