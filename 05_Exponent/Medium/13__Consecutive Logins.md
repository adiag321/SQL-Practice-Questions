## Consecutive Logins

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/practice/prepare/consecutive-logins |

---

#### Problem Statement

You want to understand how often users log in to your company’s website. You're given a table named `user_activity_log` with the following columns:

| Column Name | Type | Description |
| :--- | :--- | :--- |
| **`user_id`** | `INT` | Unique identifier for each user. |
| **`timestamp`** | `DATETIME` | The exact time the user performed an activity. |
| **`activity_type`** | `VARCHAR` | The type of activity the user has performed. The only two types of activities are `LOGIN` and `LOGOUT`. |

Write a SQL query that determines the time elapsed (in minutes) between consecutive logins for each user. The result should show each user and the gap between their logins.

Your output should contain the following columns:
- `user_id`
- `current_login`
- `previous_login`
- `minutes_elapsed` (rounded to the nearest minute)

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS user_activity_log;

CREATE TABLE user_activity_log (
    user_id INT,
    timestamp TIMESTAMP,
    activity_type VARCHAR(50)
);

INSERT INTO user_activity_log (user_id, timestamp, activity_type) VALUES
(1, '2024-01-01 10:00:00', 'LOGIN'),
(1, '2024-01-01 12:00:00', 'LOGOUT'),
(1, '2024-01-02 10:30:00', 'LOGIN'),
(2, '2024-01-01 09:00:00', 'LOGIN'),
(2, '2024-01-01 09:15:00', 'LOGOUT'),
(2, '2024-01-01 10:00:00', 'LOGIN');
```

---

#### Solution

```sql
WITH ConsecutiveLogins AS (
    SELECT
        user_id,
        timestamp AS current_login,
        LAG(timestamp) OVER (PARTITION BY user_id ORDER BY timestamp) AS previous_login
    FROM
        user_activity_log
    WHERE
        activity_type = 'LOGIN'
)
SELECT
    user_id,
    current_login,
    previous_login,
    ROUND(EXTRACT(EPOCH FROM (current_login - previous_login)) / 60) AS minutes_elapsed
FROM
    ConsecutiveLogins
WHERE
    previous_login IS NOT NULL;
```

---

#### Sample Output

| user_id | current_login | previous_login | minutes_elapsed |
|---------|---------------|----------------|-----------------|
| 1       | 2024-01-02 10:30:00 | 2024-01-01 10:00:00 | 1470 |
| 2       | 2024-01-01 10:00:00 | 2024-01-01 09:00:00 | 60 |
