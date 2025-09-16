<p align ='center'>Quesition on Window Functions</p>

#### Question 1: Find the top 5 most watched videos for every Youtube channel
Imagine you work with Youtube data and have access to a table containing one row per video and each column provides some additional information such as the total number of views and channel. Your stakeholder asks Can you find me the top 5 videos (based on their total views) for every channel?

Create and Insert Statements: 
```sql
CREATE TABLE youtube_videos (
    channel_id VARCHAR(50) NOT NULL,
    video_id VARCHAR(50) NOT NULL,
    view_count BIGINT
);

-- Insert all sample data
INSERT INTO youtube_videos (channel_id, video_id, view_count) VALUES
('02ea5750bca81c9', '3389bba412ddf3626c5a45c1', 20611),
('02ea5750bca81c9', 'a448b6084ce42607c805a268', 22229),
('02ea5750bca81c9', '42cb4240a000ab8e665d535c', 29129),
('02ea5750bca81c9', 'ee69bacc234567c4342eeb46', 66342),
('02ea5750bca81c9', 'a9b8a8728210b08010b70497', 78954),
('02ea5750bca81c9', '41a9b8a8728210b08010e8b4', 5385),
('02ea5750bca81c9', 'e2b27ef23b07dae88025a0b7', 309439),
('02ea5750bca81c9', 'abcde12345', 50000),
('02ea5750bca81c9', 'fghij67890', 15000),
('02ea5750bca81c9', 'klmno11223', 25000),
('0ec9149edad51cb', '4f5214881aab8d5a6117b0ec', 4),
('0ec9149edad51cb', '7323811a4551a88bb424dd71', 76),
('0ec9149edad51cb', 'pqrst44556', 50),
('0ec9149edad51cb', 'uvwxy77889', 100),
('new_channel_1', 'z12345', 100000),
('new_channel_1', 'a45678', 200000),
('new_channel_1', 'b78901', 300000),
('new_channel_1', 'c01234', 400000),
('new_channel_1', 'd98765', 500000),
('new_channel_1', 'e54321', 50000),
('new_channel_2', 'f98765', 10),
('new_channel_2', 'g54321', 20),
('new_channel_2', 'h23456', 30);
```

Solution: 
```sql
SELECT
channel_id,
video_id,
view_count,
Qualify ROW_NUMBER() OVER (PARTITION BY channel_id ORDER BY view_count DESC) <=5
FROM youtube_videos;
```

#### Question 2: Get the most up-to-date subscription data available for each customer
Imagine you have a table with subscription data, but every time the subscription gets updated in some way a new row is created. You are asked, Can you tell me what percentage of our active subscribers have a monthly membership?

Create and Insert Statements: 
```sql
-- Create the subscriptions table
CREATE TABLE subscriptions (
    subscription_start_date DATE,
    subscription_id VARCHAR(50),
    started_with_trial BOOLEAN,
    billing_frequency VARCHAR(20),
    last_update_date TIMESTAMP WITH TIME ZONE
);

-- Insert sample data
INSERT INTO subscriptions (subscription_start_date, subscription_id, started_with_trial, billing_frequency, last_update_date) VALUES
('2017-07-26', '4e72c47b', TRUE, 'monthly', '2017-07-26 23:36:15.000000 UTC'),
('2017-07-26', '4e72c42e', FALSE, 'yearly', '2017-07-26 14:31:03.000000 UTC'),
('2017-06-19', '4e72b0bf', TRUE, 'monthly', '2017-06-19 17:36:28.000000 UTC'),
('2017-06-19', '4e72b0bf', FALSE, 'monthly', '2017-06-19 21:54:20.000000 UTC'),
('2017-06-19', '3p72b0c4', TRUE, 'monthly', '2017-06-19 17:36:28.000000 UTC'),
('2019-07-26', '5g809dc2', FALSE, 'monthly', '2019-07-26 09:41:58.000000 UTC'),
('2019-07-26', '4e796360', TRUE, 'monthly', '2019-07-26 15:23:51.000000 UTC'),
('2019-07-26', '4e7960b8', TRUE, 'monthly', '2019-07-26 07:22:09.000000 UTC'),
('2019-07-26', '3b824589', TRUE, 'monthly', '2019-07-26 05:22:40.000000 UTC'),
('2019-07-26', '4e796613', TRUE, 'monthly', '2019-07-26 21:52:31.000000 UTC'),
('2019-07-26', '3a995243', TRUE, 'monthly', '2019-07-26 20:05:15.000000 UTC'),
('2019-07-26', '5g6809dc', TRUE, 'yearly', '2019-07-26 20:34:29.000000 UTC'),
('2019-07-26', '6j6809dc', TRUE, 'monthly', '2019-07-26 03:37:53.000000 UTC'),
('2019-07-26', '6k6709pg', TRUE, 'monthly', '2019-07-26 10:42:21.000000 UTC');
```

Solution: 
```sql
with recent_bill as 
(
    SELECT
    subscription_id,
    billing_frequency,
    ROW_NUMBER() OVER(PARTITION BY subscription_id ORDER BY last_update_date DESC) AS rn
    FROM subscriptions
)

select
sum(case when billing_frequency = 'monthly' then 1 else 0 end)*100.00/count(*) as Monthly_membership
from recent_bill
where rn = 1;
```

#### Question 3: Calculate the cumulative revenue while retaining monthly revenue


Create and Insert Statements: 
```sql
-- Create the monthly_revenue table
CREATE TABLE monthly_revenue (
    date DATE,
    revenue DECIMAL(10, 2)
);

-- Insert sample data from the image
INSERT INTO monthly_revenue (date, revenue) VALUES
('2022-11-01', 169414.70),
('2022-12-01', 13957.60),
('2020-07-01', 19581.10),
('2021-04-01', 24879.00),
('2021-07-01', 26747.40),
('2019-05-01', 3380.90);
```

Solution 1: 
```sql
SELECT
    date,
    revenue,
    SUM(revenue) OVER (ORDER BY date) AS cumulative_revenue
FROM monthly_revenue;
```

Solution 2: 
```sql
SELECT
    date,
    revenue,
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month,
    SUM(revenue) AS total_monthly_revenue
FROM
    monthly_revenue
GROUP BY
date, revenue, year, month
ORDER BY year, month;
```


#### Question 4: Find the first and last time each user was active on each platform
Imagine you have activity data for each one of your users. Users could be active on either Desktop or Mobile. Your stakeholders approach you and ask you to put together a summary of each user activity along with the first and last time they were active on each platform.

Create and Insert Statements: 
```sql
-- Create the user_activity table
CREATE TABLE user_activity (
    activity_date DATE,
    platform VARCHAR(20),
    user_id VARCHAR(50),
    plays INT,
    downloads INT
);

-- Insert sample data with varied activity dates
INSERT INTO user_activity (activity_date, platform, user_id, plays, downloads) VALUES
('2019-01-07', 'Mobile', '13b71d6f91ab81', 47, 19),
('2019-01-08', 'Mobile', '13b71d6f91ab81', 12, 5),
('2019-01-05', 'Mobile', '13b71d6f91ab81', 25, 8),
('2019-01-07', 'Desktop', '5a07edac1a336f', 25, 5),
('2019-01-09', 'Desktop', '5a07edac1a336f', 40, 10),
('2019-01-07', 'Mobile', 'b7047a6a5ec0d4', 34, 3),
('2019-01-07', 'Desktop', '2216df5337ee24', 110, 13),
('2019-01-07', 'Desktop', '768b6f97687129', 18, 4),
('2019-01-07', 'Mobile', 'a6ab2100403dac', 7, 5),
('2019-01-08', 'Desktop', '2646c993ceb3c6f', 8, 5),
('2019-01-07', 'Desktop', '3848287b83eb4fb', 6, 5),
('2019-01-07', 'Desktop', 'fdc457eabc7dbcf', 32, 26),
('2019-01-07', 'Desktop', 'c9eff36a46c7c61a', 3, 3);
```

Solution 1: 
```sql
select
user_id,
platform,
min(activity_date) as first_activity,
max(activity_date) as last_activity
from user_activity
group by 1,2
order by 1
```
`Solution 2:`
```sql
select
distinct user_id,
platform,
MIN(activity_date) OVER (PARTITION BY platform, user_id) as first_activity,
MAX(activity_date) OVER (PARTITION BY platform, user_id) as last_activity
from user_activity
group by user_id, platform, activity_date
order by 1;
```

#### `Question 5: Calculate Month-over-Month revenue growth`
If you have revenue table and your stakeholders approach you and asks How well is the company growing its sales revenue over a given time period, for example year-over-year?

Create and Insert Statements: 
```sql
CREATE TABLE monthly_revenue (
    date DATE,
    revenue DECIMAL(10, 2)
);

INSERT INTO monthly_revenue (date, revenue) VALUES
('2019-01-01', 5000.00), ('2019-02-01', 5500.00), ('2019-03-01', 6100.00), ('2019-04-01', 6800.00),
('2019-05-01', 3380.90), ('2019-06-01', 8000.00), ('2019-07-01', 8500.00), ('2019-08-01', 9000.00),
('2019-09-01', 9500.00), ('2019-10-01', 10000.00), ('2019-11-01', 11000.00), ('2019-12-01', 12000.00),
('2020-01-01', 13000.00), ('2020-02-01', 14000.00), ('2020-03-01', 15000.00), ('2020-04-01', 16000.00),
('2020-05-01', 17000.00), ('2020-06-01', 18000.00), ('2020-07-01', 19581.10), ('2020-08-01', 20000.00),
('2020-09-01', 21000.00), ('2020-10-01', 22000.00), ('2020-11-01', 23000.00), ('2020-12-01', 24000.00),
('2021-01-01', 25000.00), ('2021-02-01', 26000.00), ('2021-03-01', 27000.00), ('2021-04-01', 24879.00),
('2021-05-01', 29000.00), ('2021-06-01', 30000.00), ('2021-07-01', 26747.40), ('2021-08-01', 32000.00),
('2021-09-01', 33000.00), ('2021-10-01', 34000.00), ('2021-11-01', 35000.00), ('2021-12-01', 36000.00),
('2022-11-01', 169414.70), ('2022-12-01', 13957.60);
```

Solution: 
```sql
WITH yearly_revenue AS (
    SELECT
    EXTRACT(YEAR FROM date) AS year,
    SUM(revenue) AS total_revenue
    FROM monthly_revenue
    GROUP BY year
)
SELECT
    year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year) AS previous_year_revenue,
    (total_revenue - LAG(total_revenue) OVER (ORDER BY year)) * 100 / LAG(total_revenue) OVER (ORDER BY year) AS yoy_growth_percentage
FROM yearly_revenue
ORDER BY year;

```