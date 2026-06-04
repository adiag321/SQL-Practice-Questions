## Histogram of Tweets

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | CTE · Aggregation · Date Functions |
| **Companies** | Twitter |
| **Link** | https://datalemur.com/questions/sql-histogram-tweets |

---

#### Problem Statement

Assume you're given a table of Twitter tweet data. Write a query to obtain a **histogram of tweets posted per user** in 2022. Output the tweet count per user as the bucket and the number of users who fall into that bucket.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS tweets;

CREATE TABLE tweets (
    tweet_id   INTEGER,
    user_id    INTEGER,
    msg        VARCHAR(280),
    tweet_date TIMESTAMP
);

INSERT INTO tweets (tweet_id, user_id, msg, tweet_date) VALUES
-- User 111: 2 tweets in 2022
(1, 111, 'Hello world',        '2022-06-01 12:00:00'),
(2, 111, 'Another tweet',      '2022-08-15 12:00:00'),
-- User 222: 2 tweets in 2022
(3, 222, 'My first tweet',     '2022-01-10 12:00:00'),
(4, 222, 'Check this out',     '2022-03-22 12:00:00'),
-- User 333: 1 tweet in 2022
(5, 333, 'Just one tweet',     '2022-11-05 12:00:00'),
-- User 444: tweet in 2021 (excluded)
(6, 444, 'Old tweet',          '2021-12-31 12:00:00');
-- Expected: bucket 1 → 1 user (333), bucket 2 → 2 users (111, 222)
```

---

#### Solution

```sql
WITH CT AS (
    SELECT user_id, COUNT(tweet_id) AS tweet_bucket
    FROM tweets
    WHERE DATE_PART('YEAR', tweet_date) = 2022
    GROUP BY user_id
)

SELECT tweet_bucket, COUNT(user_id) AS users_num
FROM CT
GROUP BY tweet_bucket;
```

---

#### Sample Output

| tweet_bucket | users_num |
|--------------|-----------|
| 1            | 1         |
| 2            | 2         |
