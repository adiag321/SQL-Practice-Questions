## Revenue share per product.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Subqueries |
| **Companies** | Amazon |

---

#### Problem Statement

Calculate the revenue share for each product as a percentage of the total revenue across all products.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL(10,2) |
| product_id | INT |

```sql
CREATE TABLE orders (
    order_id   INT PRIMARY KEY,
    user_id    INT,
    order_date DATE,
    amount     DECIMAL(10,2),
    product_id INT
);
```

---

#### Solution

```sql
-- Product revenue share
with total_spend as (select
sum(amount) as total_rev
from orders
)
select
product_id,
sum(amount) as total_sold,
round(sum(amount)*100.00/(select total_rev from total_spend), 2) as rev_share
from orders
group by product_id;
```

---

#### Sample Output

| product_id | total_sold | rev_share |
|------------|------------|-----------|
| 101        | 224.95     | 35.71     |
| 102        | 234.96     | 37.3      |
| 103        | 139.98     | 22.22     |
| 104        | 29.99      | 4.76      |
