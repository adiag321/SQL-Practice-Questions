## Spending tiers: low/medium/high.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | CASE WHEN |
| **Companies** | Any |

---

#### Problem Statement

Categorize users into spending tiers (low, medium, high) based on their average order amount.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT (PK) |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL(10,2) |
| product_id | INT |

---

#### Solution

```sql
-- Spending tiers
select user_id,
avg(amount) as total_amt_spnt,
count(distinct product_id) as total_prods,
case when avg(amount) < 30 then 'low'
     when avg(amount) between 30 and 50 then 'medium'
     when avg(amount) > 50 then 'High' end as spending_tier
from orders
group by 1