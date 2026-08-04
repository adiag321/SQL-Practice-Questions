## Post Success By Interface

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** |  https://www.tryexponent.com/courses/data-science/sql-interviews/post-success-by-interface|

---

#### Problem Statement

You are given the following tables:

`post` table:
```text
post_id | post_date | user_id | interface | is_successful_post
--------+-----------+---------+-----------+-------------------
integer | timestamp | integer | string    | boolean
```

`post_user` table:
```text
user_id | user_type | age
--------+-----------+--------
integer | string    | integer
```

Write an SQL query that calculates the success rate (in percentage) of posts originating from various iPhone models.

Your output should have the following columns: `interface`, `post_success` (no. of successful posts), `post_attempt` (no. of posts), `post_success_rate` (Round to 2 decimal place). Order by descending success rate.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS post_user;

CREATE TABLE post_user (
    user_id INTEGER PRIMARY KEY,
    user_type VARCHAR(50),
    age INTEGER
);

CREATE TABLE post (
    post_id INTEGER PRIMARY KEY,
    post_date TIMESTAMP,
    user_id INTEGER,
    interface VARCHAR(50),
    is_successful_post BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES post_user(user_id)
);

INSERT INTO post_user (user_id, user_type, age) VALUES
(1, 'regular', 25),
(2, 'premium', 30),
(3, 'regular', 22);

INSERT INTO post (post_id, post_date, user_id, interface, is_successful_post) VALUES
(1, '2024-01-01 10:00:00', 1, 'Iphone 13', TRUE),
(2, '2024-01-01 11:00:00', 2, 'Iphone 14', FALSE),
(3, '2024-01-01 12:00:00', 1, 'Iphone 13', TRUE),
(4, '2024-01-01 13:00:00', 3, 'Android', TRUE),
(5, '2024-01-01 14:00:00', 2, 'Iphone 14', TRUE);
```

---

#### Solution

```sql
SELECT
    interface,
    SUM(CASE WHEN is_successful_post IS TRUE THEN 1 ELSE 0 END) AS post_success,
    COUNT(*) AS post_attempt,
    ROUND(SUM(CASE WHEN is_successful_post IS TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS post_success_rate
FROM post
WHERE interface LIKE 'Iphone%'
GROUP BY 1
ORDER BY post_success_rate DESC;
```

---

#### Expected Outcome

| interface | post_success | post_attempt | post_success_rate |
|-----------|--------------|--------------|-------------------|
| Iphone 13 | 2 | 2 | 100.00 |
| Iphone 14 | 1 | 2 | 50.00 |
