## Find Average Purchase Value

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/find-average-purchase-value |

---

#### Problem Statement

You are given the following tables:

`attribution`: `session_id`, `marketing_channel`, `purchase_value`

`user_sessions`: `session_id`, `ad_click_timestamp`, `user_id`

Find the average value of purchases made through each marketing channel and arrange them in descending order, starting with the channel that has the highest average purchase value. Your output should have the following columns: `marketing_channel`, `avg_purchase_value`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS attribution;
DROP TABLE IF EXISTS user_sessions;

CREATE TABLE attribution (
    session_id VARCHAR(20),
    marketing_channel VARCHAR(20),
    purchase_value FLOAT
);

CREATE TABLE user_sessions (
    session_id VARCHAR(20),
    ad_click_timestamp TIMESTAMP,
    user_id VARCHAR(20)
);

INSERT INTO attribution (session_id, marketing_channel, purchase_value) VALUES
('S1', 'Email', 50),
('S2', 'Email', 70),
('S3', 'Social', 20),
('S4', 'Social', 40),
('S5', 'Search', 100),
('S6', 'Search', 80);

INSERT INTO user_sessions (session_id, ad_click_timestamp, user_id) VALUES
('S1', '2024-01-01 10:00:00', 'U1'),
('S2', '2024-01-02 11:00:00', 'U1'),
('S3', '2024-01-03 09:00:00', 'U2'),
('S4', '2024-01-04 08:00:00', 'U2'),
('S5', '2024-01-05 12:00:00', 'U3'),
('S6', '2024-01-06 13:00:00', 'U3');
```

---

#### Solution

```sql
SELECT
    marketing_channel,
    ROUND(AVG(purchase_value), 2) AS avg_purchase_value
FROM attribution
GROUP BY 1
ORDER BY 2 DESC;
```

---

#### Sample Output

| marketing_channel | avg_purchase_value |
|--------------------|---------------------|
| Search             | 90.00               |
| Email              | 60.00               |
| Social             | 30.00               |
