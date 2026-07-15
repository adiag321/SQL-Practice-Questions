## Day with most active users.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation |
| **Companies** | Any |

---

#### Problem Statement

Find the daily active users (DAU) for each day to determine the day with the most active users.

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
-- Highest DAU day
select
action_date,
count(user_id) as daily_active_users
from user_actions
group by 1