## Products only bought by premium users.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Subqueries |
| **Companies** | Amazon |

---

#### Problem Statement

Find products that were purchased only by premium users and not by any free users.

---

#### Tables Used

**`users`**

| Column | Type |
|--------|------|
| user_id | INT |
| signup_date | DATE |
| country | TEXT |
| plan | TEXT |

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL(10,2) |
| product_id | INT |

```sql
CREATE TABLE users (
    user_id     INT PRIMARY KEY,
    signup_date DATE,
    country     TEXT,
    plan        TEXT
);

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
-- Premium-only products
select
*
from orders
where user_id in (
    select distinct user_id from users where plan = 'premium')
and product_id not in (
    select product_id from orders where user_id in (
        select distinct user_id from users where plan = 'free'))
```

---

#### Explanation

This query finds products that have been purchased by premium users and excludes any products purchased by free users.

- The first subquery selects all premium user IDs from the `users` table.
- The second subquery selects product IDs that have been bought by free users.
- The outer query returns order rows for premium users where the product ID is not in the free-user product list.

Using `distinct` in the user subqueries ensures each user is only considered once when filtering the premium and free user groups.

---

#### Sample Output

| product_id |
|------------|
| 103        |
| 104        |
