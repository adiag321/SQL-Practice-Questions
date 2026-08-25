## Reddit Users

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Companies** | Reddit |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/reddit-users |

---

#### Problem Statement

Reddit is a social platform where users can join various communities called "subreddits". Users can subscribe to these subreddits to receive and interact with content that interests them. Each subreddit focuses on a specific topic or theme, and users can post content, comment, and upvote or downvote posts.

You can make use of the following tables:

`user`: `user_id`, `username`

`user_subreddit`: `user_id`, `subreddit_id`

`subreddit`: `subreddit_id`, `name`

Write a SQL query that returns subreddits that have more than 3 users subscribed to them. The results should have the columns `subreddit_name` and `total_users`. Order the results in descending order of total users.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS user_subreddit;
DROP TABLE IF EXISTS subreddit;
DROP TABLE IF EXISTS "user";

CREATE TABLE "user" (
    user_id INTEGER PRIMARY KEY,
    username VARCHAR(50)
);

CREATE TABLE subreddit (
    subreddit_id INTEGER PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE user_subreddit (
    user_id INTEGER,
    subreddit_id INTEGER
);

INSERT INTO "user" (user_id, username) VALUES
(1, 'u1'), (2, 'u2'), (3, 'u3'), (4, 'u4'), (5, 'u5'), (6, 'u6');

INSERT INTO subreddit (subreddit_id, name) VALUES
(1, 'AskReddit'), (2, 'Funny'), (3, 'Books');

INSERT INTO user_subreddit (user_id, subreddit_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1),
(1, 2), (2, 2), (3, 2), (4, 2),
(1, 3), (2, 3);
```

---

#### Solution

```sql
SELECT
    s.name AS subreddit_name,
    COUNT(DISTINCT u.user_id) AS total_users
FROM user_subreddit AS us
JOIN "user" AS u
    ON u.user_id = us.user_id
JOIN subreddit AS s
    ON us.subreddit_id = s.subreddit_id
GROUP BY 1
HAVING COUNT(DISTINCT u.user_id) > 3
ORDER BY 2 DESC;
```

---

#### Sample Output

| subreddit_name | total_users |
|------------------|--------------|
| AskReddit        | 5            |
| Funny            | 4            |
