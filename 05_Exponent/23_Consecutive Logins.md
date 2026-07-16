# Exponent: Consecutive Logins

**Difficulty:** Medium

---

## Question

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

## Solution

### 1. SQLite (used by Exponent code editor)
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
    ROUND((julianday(current_login) - julianday(previous_login)) * 24 * 60) AS minutes_elapsed
FROM
    ConsecutiveLogins
WHERE
    previous_login IS NOT NULL;
```

### 2. PostgreSQL
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

### 3. MySQL
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
    ROUND(TIMESTAMPDIFF(MINUTE, previous_login, current_login)) AS minutes_elapsed
FROM
    ConsecutiveLogins
WHERE
    previous_login IS NOT NULL;
```