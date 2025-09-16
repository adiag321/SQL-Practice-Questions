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


#### Question 4:


Create and Insert Statements: 
```sql

```

Solution: 
```sql

```

#### Question 5:


Create and Insert Statements: 
```sql

```

Solution: 
```sql

```