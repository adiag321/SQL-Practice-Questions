## Days from signup to first order.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Date Math |
| **Companies** | Spotify |

---

#### Problem Statement

Calculate the number of days between each user's signup date and their first order date.

---

#### Tables Used

**`users`**

| Column | Type |
|--------|------|
| user_id | INT |
| signup_date | DATE |

**`orders`**

| Column | Type |
|--------|------|
| user_id | INT |
| order_date | DATE |

```sql
CREATE TABLE users (
    user_id     INT PRIMARY KEY,
    signup_date DATE
);

CREATE TABLE orders (
    user_id    INT,
    order_date DATE
);
```

---

#### Solution

```sql
-- Signup to first order days
select
u.user_id,
(julianday(min(o.order_date)) - julianday(min(u.signup_date))) as days_bw_frst_ord_sign_date
from users as u
left join orders as o
on u.user_id = o.user_id
group by 1;
```

---

#### Sample Output

| user_id | days_bw_frst_ord_sign_date |
|---------|----------------------------|
| 1       | 14                         |
| 2       | 15                         |
| 3       | 15                         |
| 4       | 38                         |
| 5       | 15                         |
| 6       | NULL                       |
