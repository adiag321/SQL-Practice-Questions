## Users with Orders but No Friend Requests Sent

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Joins · Set Operations |
| **Companies** | Meta |

---

#### Problem Statement

Find all users who have placed at least one order but have never sent a friend request.

---

#### Tables Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT (PK) |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL |
| product_id | INT |

**`friend_requests`**

| Column | Type |
|--------|------|
| id | INT (PK) |
| sender_id | INT |
| receiver_id | INT |
| request_date | DATE |
| status | TEXT |

---

#### Solution

Solution 1: Using LEFT JOIN

```sql
-- Users with orders but no friend requests sent
SELECT DISTINCT o.user_id
FROM orders o
LEFT JOIN friend_requests fr ON o.user_id = fr.sender_id
WHERE fr.sender_id IS NULL;
```

Solution 2: Using NOT IN

```sql
SELECT DISTINCT o.user_id
FROM orders o
WHERE o.user_id NOT IN (SELECT sender_id FROM friend_requests);
```
---

#### Sample Output

| user_id |
|---------|
| 8       |
| 10      |
