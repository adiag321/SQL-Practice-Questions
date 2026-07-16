## Advertiser Status

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Tags** | FULL OUTER JOIN · CASE WHEN · COALESCE |
| **Companies** | Meta (Facebook) |
| **Link** | https://datalemur.com/questions/updated-status |

---

#### Problem Statement

You have a table of Facebook advertisers with their current status and a table of daily payments. Write a query to update each advertiser's status based on whether they paid on the most recent day, using the following transition rules:

| Current Status | Paid Today? | New Status |
|----------------|-------------|------------|
| Any            | No          | CHURN      |
| CHURN          | Yes         | RESURRECT  |
| NEW / EXISTING / RESURRECT | Yes | EXISTING |
| *(not in advertiser table)* | Yes | NEW |

Output the `user_id` and `new_status`, sorted by `user_id` ascending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS advertiser;
DROP TABLE IF EXISTS daily_pay;

CREATE TABLE advertiser (
    user_id VARCHAR(50),
    status  VARCHAR(20)
);

CREATE TABLE daily_pay (
    user_id VARCHAR(50),
    paid    DECIMAL(10, 2)
);

INSERT INTO advertiser (user_id, status) VALUES
('bing',    'NEW'),
('yahoo',   'NEW'),
('alibaba', 'EXISTING'),
('baidu',   'EXISTING'),
('target',  'CHURN'),
('tesla',   'CHURN'),
('morgan',  'RESURRECT'),
('chase',   'EXISTING');

INSERT INTO daily_pay (user_id, paid) VALUES
('yahoo',   45.00),   -- NEW + paid today    → EXISTING
('alibaba', 100.00),  -- EXISTING + paid     → EXISTING
('target',  13.00),   -- CHURN + paid today  → RESURRECT
('morgan',  600.00),  -- RESURRECT + paid    → EXISTING
('fitbit',  25.00);   -- New advertiser      → NEW
-- bing, baidu, tesla, chase → no payment → CHURN
```

---

#### Solution

```sql
SELECT
    COALESCE(advertiser.user_id, daily_pay.user_id) AS user_id,
    CASE
        WHEN paid IS NULL
            THEN 'CHURN'
        WHEN paid IS NOT NULL AND status = 'CHURN'
            THEN 'RESURRECT'
        WHEN paid IS NOT NULL AND status IN ('EXISTING', 'NEW', 'RESURRECT')
            THEN 'EXISTING'
        WHEN paid IS NOT NULL AND status IS NULL
            THEN 'NEW'
    END AS new_status
FROM advertiser
FULL OUTER JOIN daily_pay
    USING (user_id)
ORDER BY user_id;
```

---

#### Sample Output

| user_id | new_status |
|---------|------------|
| alibaba | EXISTING   |
| baidu   | CHURN      |
| bing    | CHURN      |
| chase   | CHURN      |
| fitbit  | NEW        |
| morgan  | EXISTING   |
| target  | RESURRECT  |
| tesla   | CHURN      |
| yahoo   | EXISTING   |
