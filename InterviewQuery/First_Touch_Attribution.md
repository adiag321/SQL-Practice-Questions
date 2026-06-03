## First Touch Attribution

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Marketing Analytics · Window Functions · Joins |
| **Companies** | Retail & E-commerce |

Link: [Interview Query - First Touch Attribution](https://www.interviewquery.com/questions/first-touch-attribution)

---

## Problem Statement

First touch attribution is defined as the channel with which a converted user was associated when they first discovered the website. 

Calculate the **first touch attribution** for each `user_id` that converted. This means you need to find the channel of the very first session for any user who has at least one conversion recorded in the attribution table.

---

## Tables Used

**`attribution`**

| Column | Type |
|--------|------|
| session_id | INTEGER |
| channel | VARCHAR |
| conversion | BOOLEAN |

**`user_sessions`**

| Column | Type |
|--------|------|
| session_id | INTEGER |
| created_at | DATETIME |
| user_id | INTEGER |

```sql
CREATE TABLE attribution (
  session_id INTEGER,
  channel VARCHAR(255),
  conversion BOOLEAN
);

CREATE TABLE user_sessions (
  session_id INTEGER,
  created_at DATETIME,
  user_id INTEGER
);

INSERT INTO attribution (session_id, channel, conversion) VALUES
(1, 'facebook', 0),
(2, 'facebook', 1),
(3, 'email', 0),
(4, 'facebook', 0),
(5, 'email', 1);

INSERT INTO user_sessions (session_id, created_at, user_id) VALUES
(1, '2023-01-01 12:00:00', 67),
(2, '2023-01-02 12:00:00', 67),
(3, '2023-01-01 10:00:00', 66),
(4, '2023-01-01 11:00:00', 66),
(5, '2023-01-02 10:00:00', 66);
```

## Solution

```sql
WITH converted_users AS (
    -- Identify users who have at least one conversion in their history
    SELECT DISTINCT 
        u.user_id
    FROM user_sessions AS u
    JOIN attribution AS a ON u.session_id = a.session_id
    WHERE a.conversion = 1
),
ranked_sessions AS (
    -- Rank every session for the converted users by time
    SELECT 
        u.user_id,
        a.channel,
        ROW_NUMBER() OVER (
            PARTITION BY u.user_id 
            ORDER BY u.created_at ASC
        ) AS rnk
    FROM user_sessions AS u
    JOIN attribution AS a ON u.session_id = a.session_id
    WHERE u.user_id IN (SELECT user_id FROM converted_users)
)
-- Select the channel associated with the very first session (rnk = 1)
SELECT 
    user_id,
    channel
FROM ranked_sessions
WHERE rnk = 1;
```
