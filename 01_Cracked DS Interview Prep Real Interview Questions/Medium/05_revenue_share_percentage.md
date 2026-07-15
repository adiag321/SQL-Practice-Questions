## Revenue share percentage per product

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Aggregation · Window Functions |
| **Companies** | Shopify · Amazon |

---

#### Problem Statement

Find the percentage of total revenue each product contributes. Calculate the total revenue for each product and determine what percentage of the overall revenue it represents.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT (PK) |
| product_id | INT |
| amount | DECIMAL |
| order_date | DATE |

```sql
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  product_id INT,
  amount DECIMAL(10, 2),
  order_date DATE
);

INSERT INTO orders (order_id, product_id, amount, order_date) VALUES
(1, 101, 100.00, '2024-01-10'),
(2, 102, 150.00, '2024-01-11'),
(3, 101, 124.95, '2024-01-12'),
(4, 103, 75.50, '2024-01-13'),
(5, 102, 84.95, '2024-01-14'),
(6, 104, 29.99, '2024-01-15'),
(7, 103, 64.48, '2024-01-16');
```

---

#### Solution

```sql
-- Revenue share per product
SELECT 
  product_id,
  sum(amount) as total_prod_rev,
  (select sum(amount) from orders) as total_rev,
  round(sum(amount)*100.00/(select sum(amount) from orders), 2) as perc_rev
FROM orders
GROUP BY 1
ORDER BY 4 DESC
```

---

#### Sample Output

| product_id | total_prod_rev | total_rev | perc_rev |
|-----------|----------------|-----------|----------|
| 102       | 234.95         | 629.87    | 37.30    |
| 101       | 224.95         | 629.87    | 35.71    |
| 103       | 139.98         | 629.87    | 22.22    |
| 104       | 29.99          | 629.87    | 4.76     |

---
