Consecutive Logins
Medium
Save
6

Question

Solution
You want to understand how often users log in to your company’s website. You're given a table named user_activity_log with the following columns:

user_id (INT) - Unique identifier for each user.
timestamp (DATETIME) - The exact time the user performed an activity.
activity_type (VARCHAR) - The type of activity the user has performed. The only two types of activities are LOGIN and LOGOUT.
Write a SQL query that determines the time elapsed (in minutes) between consecutive logins for each user. The result should show each user and the gap between their logins. Your output should contain the following columns: user_id, current_login, previous_login, minutes_elapsed. Round to the nearest minute

# soltuion
-- SQLite (used by code editor)
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

-- Postgresql
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
    ROUND(EXTRACT(EPOCH FROM (current_login - previous_login))/60) AS minutes_elapsed
FROM
    ConsecutiveLogins
WHERE
    previous_login IS NOT NULL;

-- MySQL
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