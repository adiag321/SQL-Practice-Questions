## Find Conversion Rates

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/find-conversion-rates |

---

#### Problem Statement

Find what percentage of link clicks convert to a purchase for each marketing channel. Return marketing_channel, avg_purchase_value, and conversion_rate in decreasing conversion-rate order.

---

#### Create & Insert Statements

The following data is illustrative and is included to make the query executable.

```sql
CREATE TABLE attribution (session_id TEXT PRIMARY KEY, marketing_channel TEXT, purchase_value NUMERIC);
CREATE TABLE user_sessions (session_id TEXT PRIMARY KEY, ad_click_timestamp TIMESTAMP, user_id TEXT);
INSERT INTO attribution VALUES ('s001', 'email', 49.99), ('s002', 'social_media', 0), ('s003', 'email', 0), ('s004', 'paid_search', 120), ('s005', 'social_media', 35), ('s006', 'paid_search', 0), ('s007', 'email', 89.99);
INSERT INTO user_sessions VALUES ('s001', '2024-01-01 08:00:00', 'u1'), ('s002', '2024-01-01 09:30:00', 'u2'), ('s003', '2024-01-02 11:00:00', 'u1'), ('s004', '2024-01-02 14:00:00', 'u3'), ('s005', '2024-01-03 10:00:00', 'u4'), ('s006', '2024-01-03 16:00:00', 'u2'), ('s007', '2024-01-04 09:00:00', 'u5');
```

---

#### Solution

The displayed percentage is returned as a numeric value such as 66.67; the percent sign is presentation-only.

```sql
-- postgresql

SELECT marketing_channel,
       ROUND(AVG(purchase_value), 2) AS avg_purchase_value,
       ROUND(100.0 * AVG(CASE WHEN purchase_value > 0 THEN 1.0 ELSE 0.0 END), 2) AS conversion_rate
FROM attribution
GROUP BY marketing_channel
ORDER BY conversion_rate DESC;
```

---

#### Sample Output

| marketing_channel | avg_purchase_value | conversion_rate |
|-------------------|--------------------|-----------------|
| email | 46.66 | 66.67% |
| paid_search | 60.00 | 50.00% |
| social_media | 17.50 | 50.00% |

> The displayed percentage is returned as a numeric value such as 66.67; the percent sign is presentation-only.
