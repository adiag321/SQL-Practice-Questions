## App Click-through Rate (CTR)

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · CASE WHEN · CTR |
| **Companies** | Facebook |
| **Link** | https://datalemur.com/questions/sql-app-ctr |

---

#### Problem Statement

Assume you have an `events` table on Facebook app analytics. Write a query to calculate the click-through rate (CTR) for each app in 2022 and round the results to 2 decimal places.

`CTR (%) = 100.0 * Number of clicks / Number of impressions`

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS events;

CREATE TABLE events (
    app_id     INTEGER,
    event_type VARCHAR(20),
    timestamp  DATETIME
);

INSERT INTO events (app_id, event_type, timestamp) VALUES
(123, 'impression', '2022-01-01 10:00:00'),
(123, 'impression', '2022-01-02 10:00:00'),
(123, 'click',      '2022-01-03 10:00:00'),
(234, 'impression', '2022-01-04 10:00:00'),
(234, 'click',      '2022-01-05 10:00:00'),
-- 2021 events — should be excluded
(123, 'impression', '2021-12-31 10:00:00'),
(234, 'impression', '2021-06-01 10:00:00');
```

---

#### Solution

```sql
SELECT
    app_id,
    ROUND(
        100.0 * SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END)
        / SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END),
        2
    ) AS ctr
FROM events
WHERE DATE_PART('YEAR', timestamp) = 2022
GROUP BY app_id;
```

---

#### Sample Output

| app_id | ctr    |
|--------|--------|
| 123    | 50.00  |
| 234    | 100.00 |
