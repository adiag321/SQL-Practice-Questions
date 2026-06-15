## Sending vs. Opening Snaps

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Aggregation |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/sending-vs-opening-snaps |

---

#### Problem Statement

For each `age_bucket`, calculate the percentage of **send** activity time versus the total activity time (send + open). Return `age_bucket`, `send_perc`, and `open_perc` ordered by `age_bucket`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS activities;
DROP TABLE IF EXISTS age_breakdown;

CREATE TABLE activities (
    user_id       INTEGER,
    activity_type VARCHAR(10),   -- 'send' or 'open'
    time_spent    NUMERIC,
    age_bucket    VARCHAR(20)
);

CREATE TABLE age_breakdown (
    user_id    INTEGER,
    age_bucket VARCHAR(20)
);

-- Sample data linking users to age buckets and activity times
INSERT INTO age_breakdown (user_id, age_bucket) VALUES
(1, '18-25'),
(2, '26-35'),
(3, '18-25'),
(4, '36-45');

INSERT INTO activities (user_id, activity_type, time_spent, age_bucket) VALUES
-- 18-25 bucket
(1, 'send', 30, '18-25'),
(1, 'open', 70, '18-25'),
(3, 'send', 20, '18-25'),
(3, 'open', 80, '18-25'),
-- 26-35 bucket
(2, 'send', 50, '26-35'),
(2, 'open', 50, '26-35'),
-- 36-45 bucket
(4, 'send', 40, '36-45'),
(4, 'open', 60, '36-45');
```

---

#### Solution

```sql
WITH gp AS (
    SELECT age_bucket,
           SUM(CASE WHEN activity_type = 'open' THEN time_spent END) AS open,
           SUM(CASE WHEN activity_type = 'send' THEN time_spent END) AS send
    FROM activities
    GROUP BY age_bucket
)
SELECT gp.age_bucket,
       ROUND(send / (open + send) * 100.0, 2) AS send_perc,
       ROUND(open / (open + send) * 100.0, 2) AS open_perc
FROM gp
ORDER BY gp.age_bucket;
```

---

#### Sample Output

| age_bucket | send_perc | open_perc |
|------------|-----------|----------|
| 18-25      | 25.00     | 75.00 |
| 26-35      | 50.00     | 50.00 |
| 36-45      | 40.00     | 60.00 |
