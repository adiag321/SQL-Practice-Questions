## High Volume Low Success

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |

---

#### Problem Statement

You are given the following tables:

`post`: `post_id`, `post_date`, `user_id`, `interface`, `is_successful_post`

`post_user`: `user_id`, `user_type`, `age`

Write a SQL query to isolate users who post above the overall average total posts but also have a successful post rate below the overall average.

Your output should include the following columns: `user_id`, `post_success` (no. of successful posts), `post_attempt` (no. of posts), `post_success_rate`. Order by decreasing success rate.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS post_user;

CREATE TABLE post_user (
    user_id INTEGER,
    user_type VARCHAR(20),
    age INTEGER
);

CREATE TABLE post (
    post_id INTEGER PRIMARY KEY,
    post_date TIMESTAMP,
    user_id INTEGER,
    interface VARCHAR(20),
    is_successful_post BOOLEAN
);

INSERT INTO post_user (user_id, user_type, age) VALUES
(1, 'Free', 22),
(2, 'Premium', 30),
(3, 'Free', 25),
(4, 'Premium', 35);

INSERT INTO post (post_id, post_date, user_id, interface, is_successful_post) VALUES
(1, '2024-01-01', 1, 'mobile', 1),
(2, '2024-01-02', 1, 'mobile', 1),
(3, '2024-01-03', 1, 'web', 0),
(4, '2024-01-04', 1, 'web', 0),
(5, '2024-01-05', 1, 'mobile', 0),
(6, '2024-01-06', 1, 'web', 0),
(7, '2024-02-01', 2, 'mobile', 1),
(8, '2024-02-02', 2, 'web', 1),
(9, '2024-03-01', 3, 'mobile', 1),
(10, '2024-03-02', 3, 'web', 0),
(11, '2024-03-03', 3, 'mobile', 0),
(12, '2024-03-04', 3, 'web', 0),
(13, '2024-03-05', 3, 'mobile', 0),
(14, '2024-04-01', 4, 'mobile', 1),
(15, '2024-04-02', 4, 'web', 1),
(16, '2024-04-03', 4, 'mobile', 1);
```

---

#### Solution

```sql
WITH stats AS (
    SELECT
        user_id,
        SUM(CASE WHEN is_successful_post = 1 THEN 1 ELSE 0 END) AS post_success,
        COUNT(*) AS post_attempt,
        SUM(CASE WHEN is_successful_post = 1 THEN 1 ELSE 0 END) * 1.00 / COUNT(*) AS post_success_rate
    FROM post
    GROUP BY user_id
),
overall AS (
    SELECT
        AVG(post_attempt) AS avg_post_attempt,
        AVG(post_success_rate) AS avg_post_success_rate
    FROM stats
)
SELECT
    s.user_id,
    s.post_success,
    s.post_attempt,
    ROUND(s.post_success_rate, 2) AS post_success_rate
FROM stats AS s
CROSS JOIN overall AS o
WHERE s.post_attempt > o.avg_post_attempt
  AND s.post_success_rate < o.avg_post_success_rate
ORDER BY s.post_success_rate DESC;
```

---

#### Sample Output

| user_id | post_success | post_attempt | post_success_rate |
|---------|---------------|---------------|---------------------|
| 1       | 2             | 6             | 0.33                |
| 3       | 1             | 5             | 0.20                |
