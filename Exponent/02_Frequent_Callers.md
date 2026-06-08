## Frequent Callers

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Link** | https://www.tryexponent.com/practice/prepare/frequent-callers |

---

#### Problem Statement

Find the number of users who called three or more **distinct** people in the last week.

*Note: Asked at Meta and 5 other times.*

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS call_logs;

CREATE TABLE call_logs (
    call_id INT PRIMARY KEY,
    caller_id INT,
    receiver_id INT,
    call_date DATE
);

-- Caller 1: Called 3 DISTINCT people in the last week (Should be counted)
INSERT INTO call_logs (call_id, caller_id, receiver_id, call_date) VALUES
(1, 1, 101, '2026-05-20'),
(2, 1, 102, '2026-05-21'),
(3, 1, 103, '2026-05-22');

-- Caller 2: Called 2 DISTINCT people in the last week (Should NOT be counted)
INSERT INTO call_logs (call_id, caller_id, receiver_id, call_date) VALUES
(4, 2, 104, '2026-05-18'),
(5, 2, 105, '2026-05-19');

-- Caller 3: Called 3 people, but one call was over a week ago (Should NOT be counted)
INSERT INTO call_logs (call_id, caller_id, receiver_id, call_date) VALUES
(6, 3, 106, '2026-05-20'),
(7, 3, 107, '2026-05-21'),
(8, 3, 108, '2026-05-01'); -- Outside the 7-day window

-- Caller 4: Made 3 calls, but to the SAME person (Should NOT be counted)
INSERT INTO call_logs (call_id, caller_id, receiver_id, call_date) VALUES
(9, 4, 109, '2026-05-19'),
(10, 4, 109, '2026-05-20'),
(11, 4, 109, '2026-05-21');

-- Caller 5: Called 4 DISTINCT people in the last week (Should be counted)
INSERT INTO call_logs (call_id, caller_id, receiver_id, call_date) VALUES
(12, 5, 201, '2026-05-18'),
(13, 5, 202, '2026-05-19'),
(14, 5, 203, '2026-05-20'),
(15, 5, 204, '2026-05-22');
```

---

#### Solution

```sql
SELECT
    caller_id,
    COUNT(DISTINCT receiver_id) AS unique_calls
FROM call_logs
WHERE call_date BETWEEN CURRENT_DATE() - INTERVAL 7 DAY AND CURRENT_DATE()
GROUP BY 1
HAVING COUNT(DISTINCT receiver_id) >= 3;
```

---

#### Sample Output

| caller_id | unique_calls |
|-----------|--------------|
| 1         | 3            |
| 5         | 4            |
