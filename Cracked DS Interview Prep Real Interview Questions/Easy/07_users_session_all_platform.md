## Find users with matching skills: users who have sessions on ALL 3 platforms (ios, android, web).

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | HAVING · SET MATCHING |
| **Companies** | LinkedIn · Meta |

---

#### Problem Statement

Find users who have sessions on all 3 available platforms: ios, android, and web.

---

#### Schema Setup

```sql
-- 1. Create Table
CREATE TABLE sessions (
    session_id INT PRIMARY KEY,
    user_id INT,
    session_date DATE,
    duration_sec INT,
    platform TEXT
);
```

-- 2. Insert Sample Data
```sql
INSERT INTO sessions (session_id, user_id, session_date, duration_sec, platform) VALUES
(1, 1, '2023-01-01', 100, 'ios'),
(2, 1, '2023-01-02', 200, 'android'),
(3, 1, '2023-01-03', 150, 'web'),     -- User 1 is on all 3 platforms (Include)
(4, 2, '2023-01-01', 300, 'ios'),
(5, 2, '2023-01-02', 400, 'android'), -- User 2 is on 2 platforms (Exclude)
(6, 3, '2023-01-01', 500, 'web'),
(7, 3, '2023-01-02', 100, 'web'),     -- User 3 is on 1 platform, multiple sessions (Exclude)
(8, 4, '2023-01-01', 200, 'ios'),
(9, 4, '2023-01-02', 250, 'android'),
(10, 4, '2023-01-03', 300, 'web');    -- User 4 is on all 3 platforms (Include)
```

#### Solution

```sql
-- Users on all 3 platforms
SELECT
user_id,
count(distinct platform) as pltfrm
from sessions
group by 1
having count(distinct platform) = 3;
```

#### Expected Output
| user_id | pltfrm |
|---------|-------|
| 1       | 3     |
| 4       | 3     |