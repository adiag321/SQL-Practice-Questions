## Average Post Hiatus (Part 1)

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Date Functions · GROUP BY · HAVING |
| **Companies** | Facebook |
| **Link** | https://datalemur.com/questions/sql-average-post-hiatus-1 |

---

#### Problem Statement

Given a table of user posts, write a query to find the number of days between the **first** and **last** post of each user who made **more than one post** in 2021. Output `user_id` and `days_between`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS posts;

CREATE TABLE posts (
    user_id   INTEGER,
    post_id   INTEGER,
    post_date TIMESTAMP,
    post_content VARCHAR(200)
);

INSERT INTO posts (user_id, post_id, post_date, post_content) VALUES
-- User 151: 2 posts in 2021 → days_between = 307
(151, 1, '2021-02-10 12:00:00', 'Hello World'),
(151, 2, '2021-12-14 12:00:00', 'Year end update'),
-- User 661: 3 posts in 2021 → days_between = 360
(661, 3, '2021-01-01 12:00:00', 'New year'),
(661, 4, '2021-06-15 12:00:00', 'Mid year'),
(661, 5, '2021-12-27 12:00:00', 'Almost done'),
-- User 777: only 1 post in 2021 → excluded (HAVING COUNT > 1)
(777, 6, '2021-05-20 12:00:00', 'Solo post'),
-- User 888: posts outside 2021 → excluded by WHERE
(888, 7, '2020-03-01 12:00:00', 'Old post'),
(888, 8, '2022-01-10 12:00:00', 'New year 2022');
```

---

#### Solution

```sql
SELECT user_id, DATE_PART('DAY', MAX(post_date) - MIN(post_date)) AS days_between
FROM posts
WHERE DATE_PART('YEAR', post_date) = 2021
GROUP BY user_id
HAVING COUNT(user_id) > 1;
```

---

#### Sample Output

| user_id | days_between |
|---------|--------------|
| 151     | 307          |
| 661     | 360          |
