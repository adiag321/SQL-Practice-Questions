## Conversion rate: signup to first order.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Business Metrics |
| **Companies** | Any |

---

#### Problem Statement

Calculate the conversion rate from user signup to their first order.

---

#### Tables Used

**`users`**

| Column | Type |
|--------|------|
| user_id | INT (PK) |
| signup_date | DATE |
| country | TEXT |
| plan | TEXT |

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
select
count(distinct u.user_id) as total_users_signup,
count(distinct o.user_id) as total_orders,
round(count(distinct o.user_id)*100.00/count(distinct u.user_id), 2) as conv_pnt
from users as u
left join orders as o
on u.user_id = o.user_id