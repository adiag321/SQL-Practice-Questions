-- Day 02/30 days SQL challenge
/*
Question 1:
Write a SQL query to retrieve the IDs of the Facebook pages that have zero likes. 
The output should be sorted in ascending order based on the page IDs.
*/
-- Question 1 link ::  https://datalemur.com/questions/sql-page-with-no-likes

-- Create pages table
CREATE TABLE pages (
    page_id INTEGER PRIMARY KEY,
    page_name VARCHAR(255)
);
INSERT INTO pages (page_id, page_name) VALUES
(20001, 'SQL Solutions'),
(20045, 'Brain Exercises'),
(20701, 'Tips for Data Analysts');

-- Create page_likes table
CREATE TABLE page_likes (
    user_id INTEGER,
    page_id INTEGER,
    liked_date DATETIME,
    FOREIGN KEY (page_id) REFERENCES pages(page_id)
);
INSERT INTO page_likes (user_id, page_id, liked_date) VALUES
(111, 20001, '2022-04-08 00:00:00'),
(121, 20045, '2022-03-12 00:00:00'),
(156, 20001, '2022-07-25 00:00:00');

-- ------------------------------------------------------------------------------------------------------------------------------------
-- My Solution
-- ------------------------------------------------------------------------------------------------------------------------------------
-- Solution 1: 
select
pg.page_id
from pages as pg
where pg.page_id not in (select distinct page_id from page_likes);

-- Solution 2: using left join
select
pg.*,
pg_lk.*
from pages as pg
left join page_likes as pg_lk
on pg.page_id = pg_lk.page_id
where pg_lk.page_id is null;

-- Solution 3: Using Left Join with Group By and Having Clause
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes pl ON p.page_id = pl.page_id
GROUP BY p.page_id
HAVING COUNT(pl.page_id) = 0
ORDER BY p.page_id ASC;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- Question 2 App Click-through Rate (CTR) [Facebook SQL Interview Question]
-- ------------------------------------------------------------------------------------------------------------------------------------
/*
Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.
Definition and note:
Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
To avoid integer division, multiply the CTR by 100.0, not 100.
Expected Output Columns: app_id, ctr

Queston 2 Link :: https://datalemur.com/questions/click-through-rate
*/
-- Create the events table
CREATE TABLE events (
    app_id INTEGER,
    event_type VARCHAR(10),
    timestamp DATETIME
);
INSERT INTO events (app_id, event_type, timestamp) VALUES
(123, 'impression', '2022-07-18 11:36:12'),
(123, 'impression', '2022-07-18 11:37:12'),
(123, 'click', '2022-07-18 11:37:42'),
(234, 'impression', '2022-07-18 14:15:12'),
(234, 'click', '2022-07-18 14:16:12');

-- ------------------------------------------------------------------------------------------------------------------------------------
-- My Solution 
-- ------------------------------------------------------------------------------------------------------------------------------------

-- SQL query to calculate the click-through rate (CTR)
SELECT 
    app_id,
    ROUND((100.0 * SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) / COUNT(*)), 2) AS ctr
FROM 
    events
WHERE 
    YEAR(timestamp) = 2022
GROUP BY 
    app_id;