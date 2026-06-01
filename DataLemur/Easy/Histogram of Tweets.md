## Histogram of Tweets

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · CTE · Date Functions |
| **Companies** | Twitter |

---

#### Problem Statement

Assume you're given a table of Twitter tweet data. Write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of users who fall into that bucket.

Question Link: https://datalemur.com/questions/sql-histogram-tweets

---

#### Table Used

**`tweets`**

| Column | Type |
|--------|------|
| tweet_id | integer |
| user_id | integer |
| msg | string |
| tweet_date | timestamp |

---

#### Solution

```sql
WITH CT AS
(
SELECT user_id, COUNT(tweet_id) tweet_bucket
FROM tweets
WHERE DATE_PART('YEAR', tweet_date) = 2022
GROUP BY user_id
)

SELECT tweet_bucket, COUNT(user_id) users_num
FROM CT
GROUP BY tweet_bucket;
```

---

#### Sample Output

| tweet_bucket | users_num |
|--------------|-----------|
| 1 | 2 |
| 2 | 1 |
