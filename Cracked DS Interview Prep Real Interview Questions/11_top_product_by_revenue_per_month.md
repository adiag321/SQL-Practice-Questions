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
