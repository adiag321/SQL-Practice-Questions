# Challenging SQL Questions Asked at Meta!

### Question 1
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


> 💡 Feel free to ⭐ this repo if you find these questions helpful!