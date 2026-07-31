## Instagram Likes

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Link** | https://www.tryexponent.com/practice/prepare/instagram-likes |

---

#### Problem Statement

Instagram is a social media platform that allows users to share photos and videos. Users can like posts, and engagement is often measured using likes.

Write a SQL query that returns a table (with columns `username` and `num_popular_posts`) with the top 3 users who have created the highest number of posts with at least 100 likes.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    date_joined DATE
);

CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    likes INT,
    post_date DATE
);

INSERT INTO users VALUES
(1, 'Alice', 'alice@email.com', '2023-01-01'),
(2, 'Bob', 'bob@email.com', '2023-01-05'),
(3, 'Charlie', 'charlie@email.com', '2023-01-10'),
(4, 'David', 'david@email.com', '2023-01-15'),
(5, 'Eve', 'eve@email.com', '2023-01-20');

INSERT INTO posts VALUES
(101, 1, 120, '2023-11-01'),
(102, 1,  80, '2023-11-02'),
(103, 2, 140, '2023-11-03'),
(104, 3, 180, '2023-11-04'),
(105, 4, 150, '2023-11-05'),
(106, 4, 170, '2023-11-06'),
(107, 5, 110, '2023-11-07'),
(108, 5, 120, '2023-11-08');
```

---

#### Solution

```sql
SELECT
    u.username,
    COUNT(DISTINCT p.post_id) AS num_popular_posts
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE p.likes >= 100
GROUP BY u.user_id, u.username
ORDER BY num_popular_posts DESC
LIMIT 3;
```

---

#### Sample Output

| username | num_popular_posts |
|----------|-------------------|
| David    | 2                 |
| Eve      | 2                 |
| Alice    | 1                 |
