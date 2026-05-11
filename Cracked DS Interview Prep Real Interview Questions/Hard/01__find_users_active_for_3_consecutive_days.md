## Find users active for 3+ consecutive days.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | HARD |
| **Tags** | Window Functions, GAPS & ISLANDS |
| **Companies** | Meta, Uber |

---

#### Problem Statement

Find users who have been active for 3 or more consecutive days.

---

#### Table Used

**`user_actions`**

| Column | Type |
|--------|------|
| id | INT |
| user_id | INT |
| action_date | DATE |
| action_type | TEXT |

---

#### Solution

```sql
-- Find users active 3+ consecutive days
WITH daily AS (
    SELECT DISTINCT user_id, action_date FROM user_actions
),
with_rn AS (
    SELECT user_id, action_date,
           DATE(action_date, '-' || ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY action_date) || ' days') AS grp
    FROM daily
)
SELECT
    user_id
FROM with_rn
group by user_id, grp
having count(grp) >=3;
```

---

#### Explanation

This query identifies users who have been active for at least 3 consecutive days using the "gaps and islands" technique.

1.  **`daily` CTE**: This CTE selects distinct `user_id` and `action_date` from `user_actions` to ensure each user's activity is counted once per day.
2.  **`with_rn` CTE**: This is the core of the gaps and islands approach. It calculates a `grp` (group) identifier. `DATE(action_date, '-' || ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY action_date) || ' days')` subtracts a sequential number (row number) from the `action_date` for each user. If dates are consecutive, this calculation will result in the same `grp` value, effectively grouping consecutive days together.
3.  **Final SELECT**: The outer query groups the results by `user_id` and the calculated `grp`. It then uses a `HAVING` clause to filter for groups where the `count(grp)` is 3 or more, indicating at least 3 consecutive active days for that user.

---

#### Sample Output

| user_id |
|---------|
| 1       |
| 2       |
| 5       |
