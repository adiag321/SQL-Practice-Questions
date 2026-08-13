## Duolingo Leaderboards

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Companies** | Duolingo |
| **Link** | https://www.tryexponent.com/practice/prepare/duolingo-leaderboards |

---

#### Problem Statement

Duolingo is a platform that allows users to learn various languages through bite-sized lessons. Learners can complete multiple lessons in a day and track their progress in their desired language.

Write a SQL query that returns a table with the top 3 learners with the highest total lessons completed from 24 Sep 2023 to 30 Sep 2023 for each language. Your output should contain: `username`, `language`, `total_lessons`, `rank`.

*Note: If two or more learners have the same number of lessons completed and are within the top 3, include them all without skipping any rank positions for subsequent learners.*

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS lessons_completed;
DROP TABLE IF EXISTS lesson;
DROP TABLE IF EXISTS user;

CREATE TABLE user (
    user_id INT PRIMARY KEY,
    username VARCHAR(50)
);

CREATE TABLE lesson (
    lesson_id INT PRIMARY KEY,
    language VARCHAR(50)
);

CREATE TABLE lessons_completed (
    lesson_id INT,
    user_id INT,
    completed_date DATE
);

INSERT INTO user (user_id, username) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana'),
(5, 'Eve');

INSERT INTO lesson (lesson_id, language) VALUES
(101, 'Spanish'),
(102, 'Spanish'),
(103, 'Spanish'),
(104, 'Spanish'),
(105, 'French'),
(106, 'French'),
(107, 'French'),
(108, 'French');

-- Alice: 3 Spanish, 2 French lessons in the window
INSERT INTO lessons_completed (lesson_id, user_id, completed_date) VALUES
(101, 1, '2023-09-24'),
(102, 1, '2023-09-25'),
(103, 1, '2023-09-26'),
(105, 1, '2023-09-24'),
(106, 1, '2023-09-27');

-- Bob: 3 Spanish (tie with Alice), 1 French
INSERT INTO lessons_completed (lesson_id, user_id, completed_date) VALUES
(101, 2, '2023-09-25'),
(102, 2, '2023-09-26'),
(104, 2, '2023-09-28'),
(107, 2, '2023-09-29');

-- Charlie: 2 Spanish, 3 French
INSERT INTO lessons_completed (lesson_id, user_id, completed_date) VALUES
(101, 3, '2023-09-24'),
(103, 3, '2023-09-30'),
(105, 3, '2023-09-25'),
(106, 3, '2023-09-26'),
(108, 3, '2023-09-28');

-- Diana: 1 Spanish, 2 French (tie with Alice)
INSERT INTO lessons_completed (lesson_id, user_id, completed_date) VALUES
(104, 4, '2023-09-27'),
(105, 4, '2023-09-24'),
(107, 4, '2023-09-30');

-- Eve: 4 Spanish (top), 0 French
INSERT INTO lessons_completed (lesson_id, user_id, completed_date) VALUES
(101, 5, '2023-09-24'),
(102, 5, '2023-09-25'),
(103, 5, '2023-09-27'),
(104, 5, '2023-09-29');

-- One record outside the window (should be excluded)
INSERT INTO lessons_completed (lesson_id, user_id, completed_date) VALUES
(105, 5, '2023-10-01');
```

---

#### Solution

```sql
WITH RankedLessons AS (
    SELECT
        u.username,
        l.language,
        COUNT(lc.lesson_id) AS total_lessons,
        DENSE_RANK() OVER (PARTITION BY l.language ORDER BY COUNT(lc.lesson_id) DESC) AS rank
    FROM lessons_completed lc
    JOIN user u ON lc.user_id = u.user_id
    JOIN lesson l ON lc.lesson_id = l.lesson_id
    WHERE lc.completed_date BETWEEN '2023-09-24' AND '2023-09-30'
    GROUP BY u.username, l.language
)
SELECT
    username,
    language,
    total_lessons,
    rank
FROM RankedLessons
WHERE rank <= 3
ORDER BY language, rank, username;
```

---

#### Sample Output

| username | language | total_lessons | rank |
|----------|----------|---------------|------|
| Charlie  | French   | 3             | 1    |
| Alice    | French   | 2             | 2    |
| Diana    | French   | 2             | 2    |
| Eve      | Spanish  | 4             | 1    |
| Alice    | Spanish  | 3             | 2    |
| Bob      | Spanish  | 3             | 2    |
| Charlie  | Spanish  | 2             | 3    |
