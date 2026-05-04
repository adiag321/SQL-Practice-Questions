## Premium users with no orders.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | JOINS |
| **Companies** | Any |

---

#### Problem Statement

Find premium users who have no orders. *(Note: The solution query filters for `free` plan users, reflecting the provided screenshot).*

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

---

#### Solution

```sql
-- Premium non-buyers
SELECT
u.*,
o.order_id,
o.order_date,
o.amount,
o.product_id
FROM users u
LEFT JOIN orders o
ON u.user_id=o.user_id
WHERE u.plan='free'
and o.order_id is NULL;