## Top product by revenue per month.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Aggregation |
| **Companies** | Amazon |

---

#### Problem Statement

Top product by revenue per month.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT (PK) |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL |
| product_id | INT |

```sql
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  user_id INT,
  order_date DATE,
  amount DECIMAL,
  product_id INT
);

INSERT INTO orders (order_id, user_id, order_date, amount, product_id) VALUES
(1, 1, '2024-01-10', 49.99, 103),
(2, 2, '2024-01-15', 50.00, 103),
(3, 3, '2024-01-20', 29.99, 101),
(4, 1, '2024-02-05', 34.99, 102),
(5, 2, '2024-02-10', 29.99, 102),
(6, 4, '2024-02-15', 99.99, 104),
(7, 1, '2024-03-05', 79.99, 102),
(8, 3, '2024-03-10', 89.99, 102),
(9, 2, '2024-03-15', 45.00, 105);
```

---

#### Solution

```sql
-- Top product by revenue per month
select
temp.*
from (
  SELECT
  product_id,
  strftime('%m', order_date) as mnth,
  sum(amount) as total_amt,
  rank() over(partition by strftime('%m', order_date) order by sum(amount) desc) as rnk
  from orders
  group by 1,2
  ) as temp
where temp.rnk=1
```

---

#### Sample Output

| product_id | mnth | total_amt | rnk |
|------------|------|-----------|-----|
| 103        | 01   | 99.99     | 1   |
| 102        | 02   | 64.98     | 1   |
| 102        | 03   | 169.98    | 1   |
