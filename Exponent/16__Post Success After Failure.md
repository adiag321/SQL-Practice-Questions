## Post Success After Failure

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Link** | https://www.tryexponent.com/questions/3976/post-success-after-failure |

---

#### Problem Statement

Write a SQL query that shows the success rate of a post (%) when the user's **previous post had failed**.

Your output should have the following columns: `user_id` and `next_post_sc_rate` (success rate of a post when the user's previous post had failed). Order results by increasing `next_post_sc_rate`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS post_user;

CREATE TABLE post_user (
    user_id INTEGER PRIMARY KEY,
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
(1, 'standard', 25),
(2, 'premium',  32),
(3, 'standard', 41);

-- User 1: fail → success, fail → fail
-- After a failure: 1 success out of 2 subsequent posts (next_post_sc_rate = 50%)
INSERT INTO post (post_id, post_date, user_id, interface, is_successful_post) VALUES
(1, '2024-01-01 08:00:00', 1, 'mobile', false),
(2, '2024-01-02 09:00:00', 1, 'web',    true),
(3, '2024-01-03 10:00:00', 1, 'mobile', false),
(4, '2024-01-04 11:00:00', 1, 'web',    false);

-- User 2: success → fail → success
-- After a failure: 1 success out of 1 subsequent post (next_post_sc_rate = 100%)
INSERT INTO post (post_id, post_date, user_id, interface, is_successful_post) VALUES
(5, '2024-01-01 08:00:00', 2, 'mobile', true),
(6, '2024-01-02 09:00:00', 2, 'web',    false),
(7, '2024-01-03 10:00:00', 2, 'mobile', true);

-- User 3: fail → fail → fail
-- After a failure: 0 successes out of 2 subsequent posts (next_post_sc_rate = 0%)
INSERT INTO post (post_id, post_date, user_id, interface, is_successful_post) VALUES
(8,  '2024-01-01 08:00:00', 3, 'web',    false),
(9,  '2024-01-02 09:00:00', 3, 'mobile', false),
(10, '2024-01-03 10:00:00', 3, 'web',    false);
```

---

#### Solution

```sql
WITH post_succ_cte AS (
    SELECT
        user_id,
        post_date,
        is_successful_post AS prev_post_is_succ,
        LEAD(is_successful_post) OVER (PARTITION BY user_id ORDER BY post_date) AS next_post_is_succ
    FROM post
)
SELECT
    user_id,
    SUM(CASE WHEN prev_post_is_succ = 0 AND next_post_is_succ = 1 THEN 1 ELSE 0 END)
        * 100.00 / COUNT(*) AS next_post_sc_rate
FROM post_succ_cte
GROUP BY 1
ORDER BY 2;
```

---

#### Sample Output

| user_id | next_post_sc_rate |
|---------|-------------------|
| 3       | 0.00              |
| 1       | 25.00             |
| 2       | 33.33             |
