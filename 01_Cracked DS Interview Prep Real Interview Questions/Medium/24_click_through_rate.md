## Click-through rate: ratio of purchases to logins per user

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | CASE WHEN · RATIOS |
| **Companies** | Meta |

---

#### Problem Statement

Calculate the click-through rate, which is defined as the ratio of purchases to logins per user.

---

#### Table Used

**`user_actions`**

| Column | Type |
|--------|------|
| user_id | INT |
| action_type | VARCHAR |

```sql
CREATE TABLE user_actions (
  user_id INT,
  action_type VARCHAR
);

INSERT INTO user_actions (user_id, action_type) VALUES
(1, 'login'),
(1, 'login'),
(1, 'login'),
(1, 'purchase'),
(2, 'login'),
(2, 'login'),
(2, 'login'),
(2, 'purchase'),
(3, 'login'),
(3, 'login'),
(3, 'purchase'),
(5, 'login'),
(5, 'login'),
(5, 'login'),
(5, 'login');
```

---

#### Solution

```sql
-- Purchase-to-login CTR per user
SELECT
  user_id,
  nullif(SUM(CASE WHEN action_type='purchase' THEN 1 ELSE 0 END),0) AS purchases,
  nullif(SUM(CASE WHEN action_type='login' THEN 1 ELSE 0 END),0) AS logins,
  sum(case when action_type = 'purchase' then 1 else 0 end)*100.00/sum(case when action_type = 'login' then 1 else 0 end) as ctr_ratio
from user_actions
group by 1;
```

---

#### Sample Output

| user_id | purchases | logins | ctr_ratio          |
|---------|-----------|--------|--------------------|
| 1       | 1         | 3      | 33.333333333333336 |
| 2       | 1         | 3      | 33.333333333333336 |
| 3       | 1         | 2      | 50                 |
| 5       | NULL      | 4      | 0                  |

---
