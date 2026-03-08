# 1164. Product Price at a Given Date

## Problem Description

Write a solution to find the prices of all products on `2019-08-16`. Assume the price of all products before any change is `10`.

Return the result table in any order.

Link: https://leetcode.com/problems/product-price-at-a-given-date/

## Table Schema

### Products Table

| Column Name   | Type    |
|---------------|---------|
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |

- `(product_id, change_date)` is the primary key (combination of columns with unique values) of this table.
- Each row indicates that the price of some product was changed to a new price at some date.

## Schema Setup

```sql
CREATE TABLE Products (
    product_id INT,
    new_price INT,
    change_date DATE,
    PRIMARY KEY (product_id, change_date)
);

INSERT INTO Products (product_id, new_price, change_date)
VALUES
    (1, 20, '2019-08-14'),
    (1, 30, '2019-08-15'),
    (1, 35, '2019-08-16'),
    (1, 65, '2019-08-17'),
    (2, 50, '2019-08-01'),
    (2, 65, '2019-08-02'),
    (2, 99, '2019-08-03'),
    (3, 150, '2019-08-27');
```

## Example

### Input

**Products Table:**

| product_id | new_price | change_date |
|------------|-----------|-------------|
| 1          | 20        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 1          | 65        | 2019-08-17  |
| 2          | 50        | 2019-08-01  |
| 2          | 65        | 2019-08-02  |
| 2          | 99        | 2019-08-03  |
| 3          | 150       | 2019-08-27  |

### Output

| product_id | price |
|------------|-------|
| 1          | 35    |
| 2          | 99    |
| 3          | 10    |

### Explanation

- **Product 1**: The most recent price change on or before `2019-08-16` was to `35` (on `2019-08-16`). So the price is `35`.
- **Product 2**: The most recent price change on or before `2019-08-16` was to `99` (on `2019-08-03`). So the price is `99`.
- **Product 3**: The only price change is on `2019-08-27`, which is after `2019-08-16`. Since the default price is `10`, the price is `10`.

## Solution

```sql
SELECT
    p.product_id,
    COALESCE(t.new_price, 10) AS price
FROM
    (SELECT DISTINCT product_id FROM Products) p
LEFT JOIN (
    SELECT product_id, new_price
    FROM Products
    WHERE (product_id, change_date) IN (
        SELECT product_id, MAX(change_date)
        FROM Products
        WHERE change_date <= '2019-08-16'
        GROUP BY product_id
    )
) t ON p.product_id = t.product_id;
```

## Approach

The logic handles two scenarios:

1. **Products with price changes on or before the target date** — find the most recent `change_date` on or before `2019-08-16` for each product and return the corresponding `new_price`.
2. **Products with no price changes before the target date** — these products retain the default price of `10`.

**Key points:**
- A subquery gets all distinct `product_id` values to ensure every product appears in the result.
- Another subquery finds the latest `change_date` on or before `2019-08-16` per product and retrieves the corresponding `new_price`.
- A `LEFT JOIN` combines the two, ensuring products without qualifying price changes still appear.
- `COALESCE(..., 10)` substitutes the default price of `10` when no matching price change exists.

## Complexity

- **Time Complexity**: O(n log n) due to the `GROUP BY` and `MAX` aggregation, where n is the number of rows in the Products table.
- **Space Complexity**: O(k) where k is the number of distinct products.