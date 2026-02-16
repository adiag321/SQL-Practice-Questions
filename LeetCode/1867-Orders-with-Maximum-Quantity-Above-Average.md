# 1867. Orders With Maximum Quantity Above Average

## Problem Description

You are given the table `OrdersDetails`, which contains information about the quantity of products in each order.

Write a solution to find all the **imbalanced orders**.
An order is **imbalanced** if the maximum quantity of any single product in the order is **strictly greater** than the average quantity of **every** order (including itself).

The average quantity of an order is calculated as `(total quantity of all products in the order) / (number of different products in the order)`.
The maximum quantity of an order is the highest quantity of any single product in that order.

Return the result table in any order.

Link: https://leetcode.com/problems/orders-with-maximum-quantity-above-average/

## Table Schema

### OrdersDetails Table

| Column Name | Type |
|-------------|------|
| order_id    | int  |
| product_id  | int  |
| quantity    | int  |

- `(order_id, product_id)` is the primary key (combination of columns with unique values) for this table.
- Each row represents the quantity of a specific product within a given order.

## Example

### Input

**OrdersDetails Table:**

| order_id | product_id | quantity |
|----------|------------|----------|
| 1        | 1          | 12       |
| 1        | 2          | 10       |
| 1        | 3          | 15       |
| 2        | 1          | 8        |
| 2        | 4          | 4        |
| 2        | 5          | 6        |
| 3        | 3          | 5        |
| 3        | 4          | 18       |
| 3        | 9          | 20       |
| 4        | 5          | 2        |
| 4        | 6          | 8        |
| 5        | 7          | 9        |
| 5        | 8          | 9        |
| 2        | 9          | 4        |

### Output

| order_id |
|----------|
| 1        |
| 3        |

### Explanation

The average quantity and maximum quantity per order:
- **Order 1**: avg = (12+10+15)/3 = 12.33, max = 15
- **Order 2**: avg = (8+4+6+4)/4 = 5.5, max = 8
- **Order 3**: avg = (5+18+20)/3 = 14.33, max = 20
- **Order 4**: avg = (2+8)/2 = 5, max = 8
- **Order 5**: avg = (9+9)/2 = 9, max = 9

The maximum of all average quantities = max(12.33, 5.5, 14.33, 5, 9) = **14.33**

- Order 1: max quantity (15) > 14.33 → **imbalanced** ✓
- Order 2: max quantity (8) ≤ 14.33 → not imbalanced
- Order 3: max quantity (20) > 14.33 → **imbalanced** ✓
- Order 4: max quantity (8) ≤ 14.33 → not imbalanced
- Order 5: max quantity (9) ≤ 14.33 → not imbalanced

## Solution

```sql
WITH order_stats AS (
    SELECT
        order_id,
        MAX(quantity) AS max_qty,
        AVG(quantity) AS avg_qty
    FROM OrdersDetails
    GROUP BY order_id
)
SELECT order_id
FROM order_stats
WHERE max_qty > (SELECT MAX(avg_qty) FROM order_stats);
```

## Approach

This problem can be solved using a CTE with aggregate comparisons:
1. **Calculate per-order stats**: Use `GROUP BY order_id` to compute `MAX(quantity)` and `AVG(quantity)` for each order.
2. **Find the global max average**: Use a subquery `SELECT MAX(avg_qty)` across all orders to get the threshold.
3. **Filter imbalanced orders**: Return orders where their `max_qty` is strictly greater than the global max average.

## Complexity

- **Time Complexity**: O(n) for the grouping and aggregation pass
- **Space Complexity**: O(n) for storing the intermediate CTE results
