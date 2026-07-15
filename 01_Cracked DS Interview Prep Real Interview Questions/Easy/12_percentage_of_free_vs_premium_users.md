## Find the percentage of free vs premium users.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · Subqueries |
| **Companies** | Any |

---

#### Problem Statement

Find the percentage of free vs premium users.

---

#### Table Used

**`users`**

| Column | Type |
|--------|------|
| user_id | INT (PK) |
| signup_date | DATE |
| country | TEXT |
| plan | TEXT |

---

#### Solution

```sql
SELECT plan,
  COUNT(*) AS cnt,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM users), 2) AS pct
FROM users GROUP BY plan;