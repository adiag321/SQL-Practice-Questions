## Find Premium Users Who Have Never Placed an Order

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Joins · Filtering |
| **Companies** | Netflix · Spotify |

---

#### Problem Statement

Find all users on the premium plan who have never placed any order.

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
| amount | DECIMAL |
| product_id | INT |

---

#### Solution

Solution 1: using left join
```sql
SELECT u.user_id, u.plan
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE u.plan = 'premium' AND o.order_id IS NULL;
```

Solution 2: using not in
```sql
SELECT u.user_id, u.plan
FROM users u
WHERE u.plan = 'premium' AND u.user_id NOT IN (SELECT user_id FROM orders);
```

---

#### Sample Output

| user_id | plan    |
|---------|---------|
| 9       | premium |
