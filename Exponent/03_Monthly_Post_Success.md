## Monthly Post Success Analysis

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Companies** | LinkedIn |
| **Link** | https://www.tryexponent.com/practice/prepare/monthly-post-success-analysis |

---

#### Problem Statement

Write a SQL query that shows the total amount of successful posts per user type in the current month (assume current month is Nov 2023). Your output should include the following columns: `user_type`, `post_success` (no. of successful posts), `post_attempt` (no. of posts), `post_success_rate` (range: 0.00 – 1.00). Order by descending success rate.

*Asked at LinkedIn and 4 other times.*

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS post_user;

CREATE TABLE post (
    post_id INT PRIMARY KEY,
    post_date TIMESTAMP,
    user_id INT,
    interface VARCHAR(20),
    is_successful_post BOOLEAN
);

CREATE TABLE post_user (
    user_id INT,
    user_type VARCHAR(20),
    age INT
);

INSERT INTO post_user VALUES
(1, 'Free', 22),
(2, 'Premium', 30),
(3, 'Free', 25),
(4, 'Premium', 35);

INSERT INTO post VALUES
(101, '2023-11-01', 1, 'mobile', 1),
(102, '2023-11-02', 1, 'web', 0),
(103, '2023-11-03', 2, 'mobile', 1),
(104, '2023-11-04', 2, 'web', 1),
(105, '2023-11-05', 3, 'mobile', 0),
(106, '2023-11-06', 3, 'web', 1),
(107, '2023-11-07', 4, 'mobile', 1),
(108, '2023-11-08', 4, 'web', 1),
(109, '2023-11-09', 1, 'mobile', 1),
(110, '2023-11-10', 2, 'web', 1);
```

---

#### Solution

```sql
SELECT
    pu.user_type,
    SUM(is_successful_post) AS post_success,
    COUNT(post_id) AS post_attempt,
    SUM(is_successful_post) * 1.00 / COUNT(post_id) AS post_success_rate
FROM post AS p
JOIN post_user AS pu ON p.user_id = pu.user_id
WHERE post_date BETWEEN '2023-11-01' AND '2023-11-30'
GROUP BY 1
ORDER BY post_success_rate DESC;
```

---

#### Sample Output

| user_type | post_success | post_attempt | post_success_rate |
|-----------|--------------|--------------|-------------------|
| Premium   | 4            | 4            | 1.00              |
| Free      | 3            | 6            | 0.50              |
