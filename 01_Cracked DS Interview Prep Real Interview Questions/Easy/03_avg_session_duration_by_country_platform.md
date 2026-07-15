## Avg Session Duration by Country and Platform

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Joins · Aggregation |
| **Companies** | Spotify |

---

#### Problem Statement

Find the average session duration grouped by country and platform, ordered from highest to lowest.

---

#### Tables Used

**`users`**

| Column | Type |
|--------|------|
| user_id | INT (PK) |
| signup_date | DATE |
| country | TEXT |
| plan | TEXT |

**`sessions`**

| Column | Type |
|--------|------|
| session_id | INT (PK) |
| user_id | INT |
| session_date | DATE |
| duration_sec | INT |
| platform | TEXT |

---

#### Solution

```sql
-- Avg session by country + platform
SELECT
    u.country,
    s.platform,
    AVG(duration_sec) AS avg_session
FROM users AS u
JOIN sessions AS s ON u.user_id = s.user_id
GROUP BY 1, 2
ORDER BY 3 DESC;
```

---

#### Sample Output

| country | platform | avg_session |
|---------|----------|-------------|
| UK      | ios      | 625         |
| CA      | android  | 600         |
| US      | ios      | 300         |
| US      | web      | 275         |
| CA      | ios      | 250         |
| US      | android  | 150         |