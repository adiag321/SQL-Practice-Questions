## Marketing Channel Attribution

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/marketing-channel-attribution |

---

#### Problem Statement

Identify the first-touch marketing channel for all high-value customers with CLV greater than 100. Return user_id and marketing_channel.

---

#### Create & Insert Statements

The following data is illustrative and is included to make the query executable.

```sql
CREATE TABLE attribution (session_id TEXT PRIMARY KEY, marketing_channel TEXT, purchase_value NUMERIC);
CREATE TABLE user_sessions (session_id TEXT PRIMARY KEY, ad_click_timestamp TIMESTAMP, user_id TEXT);
INSERT INTO attribution VALUES ('s1', 'email', 120), ('s2', 'social', 20), ('s3', 'paid_search', 90);
INSERT INTO user_sessions VALUES ('s1', '2024-01-02', 'u1'), ('s2', '2024-01-01', 'u1'), ('s3', '2024-01-03', 'u2');
```

---

#### Solution

```sql
-- postgresql

WITH high_value AS (
    SELECT u.user_id
    FROM user_sessions AS u
    JOIN attribution AS a ON a.session_id = u.session_id
    GROUP BY u.user_id
    HAVING SUM(a.purchase_value) > 100
), first_touch AS (
    SELECT u.user_id, MIN(u.ad_click_timestamp) AS first_touch
    FROM user_sessions AS u
    JOIN high_value AS h ON h.user_id = u.user_id
    GROUP BY u.user_id
)
SELECT f.user_id, a.marketing_channel
FROM first_touch AS f
JOIN user_sessions AS u ON u.user_id = f.user_id AND u.ad_click_timestamp = f.first_touch
JOIN attribution AS a ON a.session_id = u.session_id;
```

---

#### Sample Output

| user_id | marketing_channel |
|---------|-------------------|
| u1 | social |

