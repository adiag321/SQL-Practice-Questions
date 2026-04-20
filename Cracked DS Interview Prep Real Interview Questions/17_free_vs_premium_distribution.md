## Free vs premium distribution.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation |
| **Companies** | Any |

---

#### Problem Statement

Find the distribution of free vs premium users, calculating both the total count and the percentage for each plan.

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
COUNT(*) AS n,
ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM users),2) AS pct
FROM users
GROUP BY plan;