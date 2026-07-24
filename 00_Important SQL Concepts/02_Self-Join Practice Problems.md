## Problem 1: Month-over-Month (MoM) Percentage Change

### Problem Statement
Oftentimes, it is useful to track the growth or decline of a product's usage by calculating how much a key metric changes between months. Write a query to find the month-over-month (MoM) percentage change for Monthly Active Users (MAU).

A user is considered an "active user" in a given month if they have at least one recorded login. The output should include the month and the calculated percentage change from the previous month, rounded to two decimal places.


### Create & Insert Statements
```sql

CREATE TABLE logins (
    user_id INT,
    login_date DATE
);

INSERT INTO logins (user_id, login_date) VALUES
(1, '2018-07-01'),
(234, '2018-07-02'),
(3, '2018-07-02'),
(1, '2018-07-02'),
(1, '2018-08-05'),
(234, '2018-08-14'),
(4, '2018-08-15'),
(5, '2018-08-20'),
(1, '2018-09-01'),
(4, '2018-09-10'),
(234, '2018-10-04'),
(1, '2018-10-05'),
(5, '2018-10-05'),
(2, '2018-10-05'),
(1, '2018-01-15'),
(2, '2018-01-20'),
(3, '2018-01-25'),
(2, '2018-07-10'),
(3, '2018-07-15'),
(1, '2018-07-20');
```

### Solution 1

#### Using Window Function (Lead/Lag)
```sql
with mnth_user_cnt as (
select
DATE_FORMAT(login_date, '%m') as mnth,
count(*) as cur_mnth_active_user
from logins
group by 1
order by 1
)

select
mnth,
cur_mnth_active_user,
lead(cur_mnth_active_user) over(order by mnth) as next_mnth_user,
round((lead(cur_mnth_active_user) over(order by mnth) - cur_mnth_active_user)*100.00/cur_mnth_active_user,2) as mau_diff
from mnth_user_cnt
```

### Solution 2 (Important)

#### Using Self Join (Lag/Lead equivalent)
```sql
with mnth_user_cnt as (
select
DATE_FORMAT(login_date, '%m') as mnth,
count(*) as cur_mnth_active_user
from logins
group by 1
order by 1
)
select 
m1.mnth,
    m1.cur_mnth_active_user,
    m2.cur_mnth_active_user as next_mnth_user,
    round((m2.cur_mnth_active_user - m1.cur_mnth_active_user) * 100.00 / m1.cur_mnth_active_user, 2) as mau_diff
from mnth_user_cnt m1
join mnth_user_cnt m2
on m1.mnth = m2.mnth - 1
-- on m1.mnth = m2.mnth - Interval 1 month (if mnth is datetime instead of numeric value)
```

### Output

```
+------+-----------------------+----------------------+----------+
| mnth | cur_mnth_active_user  | next_mnth_user       | mau_diff |
+------+-----------------------+----------------------+----------+
| 01   |                     3 |                    3 |     0.00 |
| 07   |                     6 |                    4 |   -33.33 |
| 08   |                     4 |                    4 |     0.00 |
| 09   |                     2 |                    3 |    50.00 |
| 10   |                     3 |                 NULL |     NULL |
+------+-----------------------+----------------------+----------+
```

## Problem 2: Retained Users Per Month (multi-part)

### Problem Statement

Write a query that gets the number of retained users per month. In this case, retention for a given month is defined as the number of users who logged in that month who also logged in the immediately previous month. 


### Solution 1

#### Using Window Function (Lead)
```sql
with cte as (
select
distinct user_id,
date_format(login_date, '%Y-%m-01') as mnth_yr
from logins
order by 1, 2
),
cte2 as (select
user_id,
mnth_yr,
lead(mnth_yr) over(partition by user_id order by mnth_yr) as next_login_dt,
case when mnth_yr + interval 1 month = lead(mnth_yr) over(partition by user_id order by mnth_yr) then 1 else 0 end as active_users
from cte
)
select
next_login_dt,
count(*)
from cte2
where active_users = 1
group by 1
```

### Solution 2

#### Using Self Join
```sql
select
date_format(b.login_date, '%Y-%m-01') as month,
count(distinct b.user_id) as retained_users_cnt
from logins as a
join logins as b
on date_format(a.login_date, '%Y-%m-01') + interval 1 month = date_format(b.login_date, '%Y-%m-01')
and a.user_id = b.user_id
group by 1
order by 1, 2;
```

### Output

```
+--------------+----------------------+
| month        | retained_users_cnt   |
+--------------+----------------------+
| 2018-08-01   |         2            |
| 2018-09-01   |         2            |
| 2018-10-01   |         1            |
+--------------+----------------------+
```


## `Problem 3: Number of Churned Users Per Month (multi-part)`

### Problem Statement

Now we’ll take retention and turn it on its head: Write a query to find many users last month did not come back this month. i.e. the number of churned users.  


### Solution 1

#### Using Window Function (Lag)
```sql
WITH cte1 AS (
    SELECT DISTINCT 
        user_id, 
        CAST(DATE_FORMAT(login_date, '%Y-%m-01') AS DATE) AS mnth
    FROM logins
),
cte2 AS (
    SELECT 
        user_id,
        mnth,
        LEAD(mnth) OVER(PARTITION BY user_id ORDER BY mnth) AS next_mnth
    FROM cte1
)
select
mnth,
sum(CASE WHEN next_mnth IS NULL OR next_mnth > mnth + INTERVAL 1 MONTH THEN 1  ELSE 0 END) as not_returned_users
from cte2
group by 1
```

### Solution 2

#### Using Self Join
```sql
WITH active_months AS (
    -- Step 1: Get distinct user and month combinations
    SELECT DISTINCT 
        user_id, 
        CAST(DATE_FORMAT(login_date, '%Y-%m-01') AS DATE) AS current_month
    FROM logins
)
SELECT 
m1.current_month AS month,
    COUNT(m1.user_id) AS churned_users
FROM active_months m1
-- Step 2: Try to join the user's activity in the following month
LEFT JOIN active_months m2 
    ON m1.user_id = m2.user_id 
    AND m2.current_month = m1.current_month + INTERVAL 1 MONTH
-- Step 3: If m2.user_id is NULL, they did not come back next month (Churn)
where m2.user_id is null
group by 1
order by 1,2;
```

### Output

```
+------------+----------------+
| mnth       | churned_users  |
+------------+----------------+
| 2018-01-01 |              3 |
| 2018-07-01 |              2 |
| 2018-08-01 |              2 |
| 2018-09-01 |              1 |
| 2018-10-01 |              4 |
+------------+----------------+
```

## `Problem 4: Reactivated Users Per Month`

### Problem Statement

Task: Create a table that contains the number of reactivated users per month. 

Context: You now want to see the number of active users this month who have been reactivated — in other words, users who have churned but this month they became active again. Keep in mind a user can reactivate after churning before the previous month. An example of this could be a user active in February (appears in logins), no activity in March and April, but then active again in May (appears in logins), so they count as a reactivated user for May. 

### Solution 1

#### Using Window Function (Lag)
```sql
WITH active_months AS (
    -- Step 1: Get the distinct months each user was active, truncated to the first day of the month
    SELECT DISTINCT 
        user_id, 
        DATE_TRUNC('month', login_date) AS activity_month
    FROM logins
),
lagged_months AS (
    -- Step 2: Find the immediately preceding active month for each user
    SELECT 
        user_id, 
        activity_month,
        LAG(activity_month) OVER(PARTITION BY user_id ORDER BY activity_month) AS prev_activity_month
    FROM active_months
)
-- Step 3: Filter for users with a gap of >1 month between logins and aggregate
SELECT 
    activity_month AS month, 
    COUNT(user_id) AS reactivated_users
FROM lagged_months
WHERE prev_activity_month IS NOT NULL 
  -- If their previous active month is strictly before the previous calendar month, they churned and reactivated
  AND prev_activity_month < (activity_month - INTERVAL '1 month')
GROUP BY activity_month
ORDER BY activity_month;
```

### Solution 2 (Important)

#### Using Self Join (Lag/Lead equivalent)
```sql

```

### Output

```
+--------------+------------------+
| month        | reactivated_users| 
+--------------+------------------+
| 2018-07-01   | 3                |
| 2018-10-01   | 3                |
+--------------+------------------+
```
