## Active User Retention

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Tags** | CTE · CASE WHEN · Date Functions |
| **Companies** | Meta (Facebook) |
| **Link** | https://datalemur.com/questions/user-retention |

---

#### Problem Statement

Assume you have the table below containing information on Facebook user actions. Write a query to obtain the number of monthly active users (MAUs) in July 2022, i.e., users who were active in **both** June 2022 and July 2022.

Output the `month` (as `7`) and the `monthly_active_users` count.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS user_actions;

CREATE TABLE user_actions (
    user_id    INTEGER,
    event_id   INTEGER,
    event_type VARCHAR(20),
    event_date TIMESTAMP
);

INSERT INTO user_actions (user_id, event_id, event_type, event_date) VALUES
-- Active in BOTH June and July 2022 → counted as MAU
(445, 7765, 'sign-in', '2022-05-31 12:00:00'),
(445, 8760, 'like',    '2022-06-22 12:00:00'),
(445, 8761, 'comment', '2022-07-10 12:00:00'),
(742, 6458, 'sign-in', '2022-06-03 12:00:00'),
(742, 6459, 'like',    '2022-06-15 12:00:00'),
(742, 6460, 'comment', '2022-07-02 12:00:00'),
-- Active ONLY in July → not counted
(321, 9900, 'sign-in', '2022-07-01 12:00:00'),
-- Active ONLY in June → not counted
(854, 5500, 'like',    '2022-06-18 12:00:00'),
-- Active in May and July but NOT June → not counted
(123, 1001, 'sign-in', '2022-05-10 12:00:00'),
(123, 1002, 'comment', '2022-07-20 12:00:00');
```

---

#### Solution

```sql
WITH CTE AS (
    SELECT
        user_id,
        SUM(
            CASE
                WHEN DATE_PART('MONTH', event_date) = 6
                 AND DATE_PART('YEAR', event_date) = 2022 THEN 1
                ELSE 0
            END
        ) AS jun,
        SUM(
            CASE
                WHEN DATE_PART('MONTH', event_date) = 7
                 AND DATE_PART('YEAR', event_date) = 2022 THEN 1
                ELSE 0
            END
        ) AS jul
    FROM user_actions
    GROUP BY user_id
)

SELECT
    '7' AS month,
    COUNT(user_id) AS monthly_active_users
FROM CTE
WHERE jun > 0
  AND jul > 0;
```

---

#### Sample Output

| month | monthly_active_users |
|-------|----------------------|
| 7     | 2                    |
