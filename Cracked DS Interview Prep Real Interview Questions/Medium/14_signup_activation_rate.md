## Signup activation rate: % of users who placed an order within 7 days of signup.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | JOINS, ACTIVATION |
| **Companies** | TikTok, Meta |

---

#### Problem Statement

Calculate the signup activation rate, defined as the percentage of users who placed an order within 7 days of their signup date.

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
    order_date DATE
);
```

---

#### Solution

```sql
SELECT
round(sum(CASE WHEN julianday(o.order_date) - julianday(u.signup_date) <= 7
    THEN 1 else 0 END)*100.00/count(distinct u.user_id), 2) as activation_pct
FROM users u
LEFT JOIN orders o
ON u.user_id = o.user_id;
```

---

#### Sample Output

| activation_pct |
|----------------|
| 70.0           |
