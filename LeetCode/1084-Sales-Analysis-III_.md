# 1084. Sales Analysis III - IMPORTANT

## Problem Description

Write a solution to report the products that were **only** sold in the first quarter of 2019. That is, between **2019-01-01** and **2019-03-31** inclusive.
Return the result table in any order.

Link: https://leetcode.com/problems/sales-analysis-iii/

## Table Schema

### Product Table

| Column Name  | Type    |
|--------------|---------|
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |

- `product_id` is the primary key (column with unique values) for this table.
- Each row of this table indicates the name and the price of each product.

### Sales Table

| Column Name | Type |
|-------------|------|
| seller_id   | int  |
| product_id  | int  |
| buyer_id    | int  |
| sale_date   | date |
| quantity    | int  |
| price       | int  |

- This table can have duplicate rows.
- `product_id` is a foreign key (reference column) to the `Product` table.
- Each row of this table contains information about one sale.

## Example

### Input

**Product Table:**

| product_id | product_name | unit_price |
|------------|--------------|------------|
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |

**Sales Table:**

| seller_id | product_id | buyer_id | sale_date  | quantity | price |
|-----------|------------|----------|------------|----------|-------|
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |

### Output

| product_id | product_name |
|------------|--------------|
| 1          | S8           |

### Explanation

- The product with id = 1 (S8) was only sold in the first quarter of 2019.
- The product with id = 2 (G4) was sold in the first quarter of 2019 but was also sold after the first quarter (2019-06-02).
- The product with id = 3 (iPhone) was sold only after the first quarter of 2019 (2019-05-13).

## Solution 1 (Important)

```sql
SELECT
    p.product_id,
    p.product_name
FROM Product p
JOIN Sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
HAVING MIN(s.sale_date) >= '2019-01-01'
   AND MAX(s.sale_date) <= '2019-03-31';
```

## Solution 2

```sql
with prod_after_frst_qtr as (
    select
    product_id
    from Sales
    where Sale_date >= '2019-04-01'
)
select
product_id,
product_name
from Product
where product_id in (
    select
    s.product_id
    from Sales as s
    where s.sale_date between '2019-01-01' and '2019-03-31')
and product_id not in (
    select 
    product_id 
    from prod_after_frst_qtr
)
```

## Approach

This problem can be solved using a `GROUP BY` with `HAVING` conditions:
1. **Join** the `Product` and `Sales` tables on `product_id`.
2. **Group by** `product_id` and `product_name` to aggregate all sales per product.
3. **Filter with HAVING**: Use `MIN(sale_date) >= '2019-01-01'` and `MAX(sale_date) <= '2019-03-31'` to ensure that **all** sales for the product fall within Q1 2019. If the earliest sale is on or after Jan 1 and the latest sale is on or before Mar 31, then every sale must be within Q1.

## Complexity

- **Time Complexity**: O(n log n) due to the grouping and aggregation operations
- **Space Complexity**: O(n) for storing the results
