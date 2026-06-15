## International Call Percentage

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Aggregation · Conditional Sum |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/international-call-percentage |

---

#### Problem Statement

Calculate the percentage of phone calls that are **international** (caller and receiver in different countries) out of all calls. Return the percentage rounded to one decimal place.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS phone_calls;
DROP TABLE IF EXISTS phone_info;

CREATE TABLE phone_calls (
    call_id    INTEGER PRIMARY KEY,
    caller_id  INTEGER,
    receiver_id INTEGER
);

CREATE TABLE phone_info (
    caller_id   INTEGER PRIMARY KEY,
    country_id  INTEGER,
    phone_number VARCHAR(20)
);

INSERT INTO phone_info (caller_id, country_id, phone_number) VALUES
(1, 1, '+1-202-555-0100'), -- USA
(2, 2, '+44-20-7946-0958'), -- UK
(3, 1, '+1-303-555-0199'), -- USA
(4, 3, '+81-3-1234-5678'); -- Japan

INSERT INTO phone_calls (call_id, caller_id, receiver_id) VALUES
(1, 1, 2), -- international
(2, 1, 3), -- domestic
(3, 2, 4), -- international
(4, 3, 1), -- domestic
(5, 4, 1); -- international
```

---

#### Solution

```sql
WITH International_Call AS (
    SELECT SUM(CASE WHEN caller.country_id != receiver.country_id THEN 1.0 ELSE 0.0 END) AS Number_internationals
    FROM phone_calls pc
    INNER JOIN phone_info caller   ON pc.caller_id   = caller.caller_id
    INNER JOIN phone_info receiver ON pc.receiver_id = receiver.caller_id
)
SELECT ROUND((Number_internationals * 100.0 / (SELECT COUNT(*) FROM phone_calls)), 1) AS international_percentage
FROM International_Call;
```

---

#### Sample Output

| international_percentage |
|--------------------------|
| 60.0 |
