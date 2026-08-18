## Post Success By Age Group

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/practice/prepare/post-success-by-age-group |

---

#### Problem Statement

Write a SQL query that shows the difference in success rate of posting between young adults (age 0–18) and non-young adults by each month.

Your output should contain the following columns: `post_month`, `ya_sc_rate` (young adults success rate), `non_ya_sc_rate` (non-young adults success rate), `diff` (difference between `ya_sc_rate` and `non_ya_sc_rate` rounded to 2 decimal places). Order by ascending month.

*Asked 19 times.*

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
    user_id INT PRIMARY KEY,
    user_type VARCHAR(20),
    age INT
);

INSERT INTO post_user (user_id, user_type, age) VALUES
(1, 'standard', 16),
(2, 'standard', 34),
(3, 'premium', 12),
(4, 'standard', 45),
(5, 'premium', 28);

-- Month 1 (January): Young adults (users 1, 3) → 2 posts, both successful
--                    Non-young adult (user 2) → 1 post, unsuccessful
INSERT INTO post (post_id, post_date, user_id, interface, is_successful_post) VALUES
(1, '2024-01-05', 1, 'mobile', true),
(2, '2024-01-12', 2, 'web', false),
(3, '2024-01-20', 3, 'mobile', true);

-- Month 2 (February): Young adult (user 1) → 1 post, unsuccessful
--                     Non-young adults (users 4, 5) → 2 posts, both successful
INSERT INTO post (post_id, post_date, user_id, interface, is_successful_post) VALUES
(4, '2024-02-03', 4, 'web', true),
(5, '2024-02-14', 1, 'mobile', false),
(6, '2024-02-22', 5, 'web', true);
```

---

#### Solution

```sql
WITH cte AS (
    SELECT
        EXTRACT(MONTH FROM p.post_date) AS month,
        p.user_id,
        CASE WHEN p.is_successful_post = true THEN 1 ELSE 0 END AS is_successful_post,
        pu.age
    FROM post AS p
    JOIN post_user AS pu ON p.user_id = pu.user_id
)
SELECT
    month AS post_month,
    SUM(CASE WHEN age <= 18 AND is_successful_post = 1 THEN 1 ELSE 0 END) * 1.00
        / SUM(CASE WHEN age <= 18 THEN 1 ELSE 0 END) AS ya_sc_rate,
    SUM(CASE WHEN age > 18 AND is_successful_post = 1 THEN 1 ELSE 0 END) * 1.00
        / SUM(CASE WHEN age > 18 THEN 1 ELSE 0 END) AS non_ya_sc_rate,
    ROUND(
        SUM(CASE WHEN age <= 18 AND is_successful_post = 1 THEN 1 ELSE 0 END) * 1.00
            / SUM(CASE WHEN age <= 18 THEN 1 ELSE 0 END), 2
    ) - ROUND(
        SUM(CASE WHEN age > 18 AND is_successful_post = 1 THEN 1 ELSE 0 END) * 1.00
            / SUM(CASE WHEN age > 18 THEN 1 ELSE 0 END), 2
    ) AS diff
FROM cte
GROUP BY 1;
```

---

#### Sample Output

| post_month | ya_sc_rate | non_ya_sc_rate | diff  |
|------------|------------|----------------|-------|
| 1          | 1.00       | 0.00           | 1.00  |
| 2          | 0.00       | 1.00           | -1.00 |