## Most common action type per user

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Aggregation · Window Functions |
| **Companies** | Meta · Spotify |

---

#### Problem Statement

Find the most common action type for each user in the `user_actions` table. If a user has more than one action type tied for most frequent, return all top action types for that user.

---

#### Table Used

**`user_actions`**

| Column | Type |
|--------|------|
| user_id | INT |
| action_type | TEXT |
| action_date | DATE |

```sql
CREATE TABLE user_actions (
  user_id INT,
  action_type TEXT,
  action_date DATE
);

INSERT INTO user_actions (user_id, action_type, action_date) VALUES
(1, 'login', '2024-01-01'),
(1, 'play', '2024-01-01'),
(1, 'login', '2024-01-02'),
(2, 'search', '2024-01-02'),
(2, 'login', '2024-01-02'),
(2, 'search', '2024-01-03'),
(3, 'play', '2024-01-03'),
(3, 'play', '2024-01-04'),
(3, 'pause', '2024-01-04');
```

---

#### Solution

```sql
WITH action_counts AS (
  SELECT
    user_id,
    action_type,
    count(action_type) AS cnt,
    rank() OVER (PARTITION BY user_id ORDER BY count(action_type) DESC) AS rnk
  FROM user_actions
  GROUP BY user_id, action_type
)

SELECT
  user_id,
  action_type
FROM action_counts
WHERE rnk = 1;
```

---

#### Sample Output

| user_id | action_type |
|---------|-------------|
| 1       | login       |
| 2       | search      |
| 3       | play        |

