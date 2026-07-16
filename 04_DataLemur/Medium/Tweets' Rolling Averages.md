## Tweets' Rolling Averages

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Aggregation |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/tweets-rolling-averages |

---

#### Problem Statement

For each `user_id`, calculate a rolling average of `tweet_count` over the current row and the two preceding rows, ordered by `tweet_date`. Return `user_id`, `tweet_date`, and the rounded rolling average.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS tweets;

CREATE TABLE tweets (
    user_id    INTEGER,
    tweet_date DATE,
    tweet_count INTEGER
);

INSERT INTO tweets (user_id, tweet_date, tweet_count) VALUES
(1, '2022-01-01', 5),
(1, '2022-01-02', 8),
(1, '2022-01-03', 7),
(1, '2022-01-04', 6),
(2, '2022-01-01', 3),
(2, '2022-01-02', 4),
(2, '2022-01-03', 5);
```

---

#### Solution

```sql
SELECT user_id,
       tweet_date,
       ROUND(AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_avg
FROM tweets;
```

---

#### Sample Output

| user_id | tweet_date | rolling_avg |
|--------|------------|-------------|
| 1 | 2022-01-01 | 5.00 |
| 1 | 2022-01-02 | 6.50 |
| 1 | 2022-01-03 | 6.67 |
| 1 | 2022-01-04 | 7.00 |
| 2 | 2022-01-01 | 3.00 |
| 2 | 2022-01-02 | 3.50 |
| 2 | 2022-01-03 | 4.00 |
