## Find Customer Lifetime Value

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/find-customer-lifetime-value |

---

#### Problem Statement

You are given attribution (session_id, marketing_channel, purchase_value) and user_sessions (session_id, ad_click_timestamp, user_id). Find customer lifetime value for each user, ordered from most valuable to least valuable. Return user_id and LTV.

---

#### Create & Insert Statements

The following data is illustrative and is included to make the query executable.

```sql
CREATE TABLE attribution (session_id TEXT PRIMARY KEY, marketing_channel TEXT, purchase_value NUMERIC);
CREATE TABLE user_sessions (session_id TEXT PRIMARY KEY, ad_click_timestamp TIMESTAMP, user_id TEXT);
INSERT INTO attribution VALUES ('s1', 'email', 120), ('s2', 'social', 40), ('s3', 'email', 75);
INSERT INTO user_sessions VALUES ('s1', '2024-01-01', 'u1'), ('s2', '2024-01-02', 'u1'), ('s3', '2024-01-03', 'u2');
```

---

#### Solution

```sql
-- postgresql

SELECT u.user_id, SUM(a.purchase_value) AS LTV
FROM attribution AS a
JOIN user_sessions AS u ON a.session_id = u.session_id
GROUP BY u.user_id
ORDER BY LTV DESC;
```

---

#### Sample Output

| user_id | LTV |
|---------|-----|
| u1 | 160 |
| u2 | 75 |

