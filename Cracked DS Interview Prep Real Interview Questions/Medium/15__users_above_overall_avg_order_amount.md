## Users above overall avg order amount.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Subqueries |
| **Companies** | Any |

---

#### Problem Statement

Find users whose average order amount is above the overall average order amount.

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
-- Above-average spenders
with avg_amt_pr_user as (
  select
  user_id,
  avg(amount) as avg_amt
  from orders
  group by 1
)
select
*,
(select avg(amount) from orders) as total_avg_amt
from avg_amt_pr_user
where avg_amt > (select avg(avg_amt) from avg_amt_pr_user);
```

---

#### Sample Output

| user_id | avg_amt | total_avg_amt |
|---------|---------|---------------|
| 3       | 79.99   | 52.49         |
| 4       | 59.99   | 52.49         |
| 5       | 54.9899 | 52.49         |
