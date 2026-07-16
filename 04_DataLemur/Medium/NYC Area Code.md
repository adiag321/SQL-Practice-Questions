## NYC Area Code

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | String Functions · Filtering |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/nyc-area-code |

---

#### Problem Statement

Count how many phone calls involve a phone number with the NYC area code `+1-212`. The call can be either as caller or receiver.

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
    phone_number VARCHAR(20)
);

INSERT INTO phone_info (caller_id, phone_number) VALUES
(1, '+1-212-555-0100'), -- NYC
(2, '+1-310-555-0111'), -- LA
(3, '+1-212-555-0122'), -- NYC
(4, '+1-415-555-0133'); -- SF

INSERT INTO phone_calls (call_id, caller_id, receiver_id) VALUES
(1, 1, 2),
(2, 2, 3),
(3, 3, 4),
(4, 4, 1),
(5, 2, 4);
```

---

#### Solution

```sql
SELECT COUNT(*) AS nyc_count
FROM phone_info pf
JOIN phone_calls pc ON pf.caller_id = pc.caller_id OR pf.caller_id = pc.receiver_id
WHERE LEFT(pf.phone_number, 6) = '+1-212';
```

---

#### Sample Output

| nyc_count |
|-----------|
| 3 |
