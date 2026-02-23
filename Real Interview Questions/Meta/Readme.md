# Challenging SQL Questions Asked at Meta!

## Question 1
You’re given a table with Facebook posts & your task is to:
* Identify users who posted at least twice in the year 2025.
* For each user, find the number of days between the first & last post within that year.
* Output the user_id & the days between the first & last post of that year.

**Input Table:**
```
| user_id | post_id | post_date           | post_content |
|---------|---------|---------------------|--------------|
| 151652  | 599415  | 2025-07-10 12:00:00 | Need a hug |
| 661093  | 624356  | 2025-07-29 13:00:00 | Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day that is gonna fly by. |
| 004239  | 784254  | 2025-07-04 11:00:00 | Happy 4th of July! |
| 661093  | 442560  | 2025-07-08 14:00:00 | Just going to clean & organize my room. |
| 151652  | 111766  | 2025-07-12 19:00:00 | Its Cheat Day! |
```

**Create and Insert Statement:**
```sql
CREATE TABLE facebook_posts (
    user_id VARCHAR(10),
    post_id INT,
    post_date DATETIME,
    post_content TEXT
);

INSERT INTO facebook_posts (user_id, post_id, post_date, post_content) VALUES
('151652', 599415, '2025-07-10 12:00:00', 'Need a hug'),
('661093', 624356, '2025-07-29 13:00:00', 'Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day that is gonna fly by.'),
('004239', 784254, '2025-07-04 11:00:00', 'Happy 4th of July!'),
('661093', 442560, '2025-07-08 14:00:00', 'Just going to clean & organize my room.'),
('151652', 222111, '2025-03-15 09:30:00', 'Morning coffee vibes'),
('151652', 333222, '2025-12-01 10:45:00', 'End of year reflections'),
('661093', 555666, '2025-02-14 08:00:00', 'Happy Valentine''s Day!'),
('661093', 555777, '2025-11-23 21:15:00', 'Thanksgiving prep starts now'),
('004239', 888999, '2025-01-01 00:01:00', 'Happy New Year!'),
('004239', 777888, '2025-10-10 16:00:00', 'Fall colors are amazing'),
('111111', 101010, '2025-05-05 14:30:00', 'Cinco de Mayo party'),
('111111', 202020, '2025-05-20 17:00:00', 'Back to work'),
('111111', 303030, '2025-08-08 07:45:00', 'Vacation time!'),
('222222', 404040, '2025-03-03 09:15:00', 'Monday grind'),
('222222', 505050, '2025-07-07 20:00:00', 'Summer nights'),
('333333', 606060, '2025-04-22 06:30:00', 'Earth Day celebrations'),
('333333', 707070, '2025-04-23 06:30:00', 'Back to work after Earth Day'),
('444444', 808080, '2025-09-01 12:00:00', 'Labor Day BBQ'),
('246801', 114333, '2025-05-30 12:15:00', 'Summer start vibes'),
('151652', 111766, '2025-07-12 19:00:00', 'Its Cheat Day!');
```

**Solution:**
```sql
select 
user_id,
DATEDIFF(MAX(post_date), MIN(post_date)) AS days_between
from facebook_posts
where extract(year from post_date) = 2025
group by user_id
having count(user_id) >= 2;
```

## Question 2 (IMPORATANT)

**Scenario:** E-commerce Conversion Funnel Analysis

**Context:** You are analyzing user behavior for an e-commerce platform. Marketing wants to understand conversion rates at each stage of the purchase funnel for the month of January 2026.

**Task:** 
Write a query to calculate funnel metrics for each day in January 2026.
1. Number of unique users who viewed any page
2. Number of unique users who viewed a product page
3. Number of unique users who added to cart
4. Number of unique users who completed a purchase
5. Overall conversion rate (purchasers / page viewers)

**Input Tables:**

**Table: `events`**
```
| event_id | user_id | event_type | event_timestamp | product_id | amount |
|----------|---------|------------|-----------------|------------|--------|
| 1        | 101     | view       | 2026-01-05 10:00:00 | 50         | NULL   |
| 2        | 102     | view       | 2026-01-05 10:05:00 | 51         | NULL   |
| 3        | 101     | add_to_cart| 2026-01-05 10:10:00 | 50         | NULL   |
| 4        | 103     | view       | 2026-01-05 10:15:00 | 52         | NULL   |
| 5        | 101     | purchase   | 2026-01-05 10:20:00 | 50         | 99.99  |
| 6        | 102     | add_to_cart| 2026-01-05 10:25:00 | 51         | NULL   |
| 7        | 104     | view       | 2026-01-06 09:00:00 | 53         | NULL   |
| 8        | 102     | purchase   | 2026-01-06 09:30:00 | 51         | 49.99  |
| 9        | 103     | purchase   | 2026-01-06 11:00:00 | 52         | 199.99 |
| 10       | 105     | view       | 2026-01-07 14:00:00 | 54         | NULL   |
| 11       | 105     | add_to_cart| 2026-01-07 14:15:00 | 54         | NULL   |
| 12       | 105     | purchase   | 2026-01-07 14:30:00 | 54         | 75.00  |
```

**Table: `products`**
```
| product_id | product_name | category |
|------------|--------------|----------|
| 50         | Wireless Headphones | Electronics |
| 51         | Mechanical Keyboard | Electronics |
| 52         | Leather Wallet | Accessories |
| 53         | Running Shoes | Footwear |
| 54         | Smart Watch | Electronics |
```

**Expected Output:**
```
| date       | views | add_to_carts | purchases | view_to_cart_rate | cart_to_purchase_rate | overall_conversion_rate |
|------------|-------|--------------|-----------|---------------------|-------------------------|-------------------------|
| 2026-01-05 | 3     | 2            | 1         | 66.67%              | 100.00%                 | 33.33%                  |
| 2026-01-06 | 1     | 1            | 2         | 100.00%             | 100.00%                 | 200.00%                 |
| 2026-01-07 | 1     | 1            | 1         | 100.00%             | 100.00%                 | 100.00%                 |
```

**Create and Insert Statement:**
```sql
CREATE TABLE page_views (
    user_id INT,
    page_type VARCHAR(20),  -- 'home', 'product', 'cart'
    view_timestamp TIMESTAMP
);
CREATE TABLE purchases (
    user_id INT,
    purchase_id INT PRIMARY KEY,
    purchase_timestamp TIMESTAMP,
    revenue DECIMAL(10,2)
);
INSERT INTO page_views (user_id, page_type, view_timestamp) VALUES
(1, 'home',    '2026-01-15 09:00:00'),
(1, 'product', '2026-01-15 09:05:00'),
(1, 'cart',    '2026-01-15 09:10:00'),
(2, 'home',    '2026-01-15 10:00:00'),
(2, 'product', '2026-01-15 10:05:00'),
(3, 'home',    '2026-01-15 11:00:00'),
(3, 'product', '2026-01-15 11:03:00'),
(3, 'cart',    '2026-01-15 11:08:00'),
(4, 'home',    '2026-01-16 08:30:00'),
(4, 'product', '2026-01-16 08:35:00'),
(5, 'home',    '2026-01-16 09:00:00'),
(6, 'home',    '2026-01-17 09:00:00'),
(6, 'product', '2026-01-17 09:05:00'),
(6, 'cart',    '2026-01-17 09:10:00'),
(6, 'purchase', '2026-01-17 09:15:00');

INSERT INTO purchases (user_id, purchase_id, purchase_timestamp, revenue) VALUES
(1, 1001, '2026-01-15 09:15:00', 120.00),
(3, 1002, '2026-01-15 11:15:00', 75.50),
(4, 1003, '2026-01-16 08:50:00', 200.00),
(6, 1004, '2026-01-17 09:15:00', 120.00);
```

**Solution:**
```sql
select * from page_views;
select * from purchases;

with daily_analysis as 
(
  select
  user_id,
  extract(day from view_timestamp) as day,
  max(case when page_type = 'product' then 1 else 0 end) as viewed_product,
  max(case when page_type = 'cart' then 1 else 0 end) as viewed_cart
  from page_views
  where extract(month from view_timestamp) = 01 and extract(year from view_timestamp) = 2026
  group by 1,2
),

daily_purchases as 
(
  select
  user_id,
  extract(day from purchase_timestamp) as day
  from purchases
  where extract(month from purchase_timestamp) = 01 and extract(year from purchase_timestamp) = 2026
  group by 1,2
)

select
da.day,
count(distinct da.user_id) as cnt_viewed_page,
count(da.viewed_product) as cnt_veiwed_product,
count(da.viewed_cart) as cnt_viewed_cart,
count(distinct dp.user_id) as cnt_completed_purchases,
round(count(distinct da.user_id)*1.0/count(distinct dp.user_id), 3) as conv_rate
from daily_analysis as da
left join daily_purchases as dp
on da.user_id = dp.user_id
and da.day = dp.day
group by 1;
```