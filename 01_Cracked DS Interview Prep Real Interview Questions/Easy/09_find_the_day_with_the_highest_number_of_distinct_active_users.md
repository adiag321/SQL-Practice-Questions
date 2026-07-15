## Find the day with the highest number of distinct active users

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · Basics |
| **Companies** | Any |

---

#### Problem Statement

Find the day with the highest number of distinct active users.

---

#### Table Used

**`user_actions`**

| Column | Type |
|--------|------|
| id | INT (PK) |
| user_id | INT |
| action_date | DATE |
| action_type | TEXT |

---

#### Solution

```sql
-- Day with most active users
SELECT
action_date,
count(distinct user_id) as cnt
from user_actions
group by 1
order by 1;
```

---

#### Sample Output

| action_date | cnt |
|-------------|-----|
| 2024-01-10  | 2   |
| 2024-01-11  | 2   |
| 2024-01-12  | 2   |
| 2024-01-13  | 1   |
| 2024-01-15  | 1   |
| 2024-01-20  | 1   |
