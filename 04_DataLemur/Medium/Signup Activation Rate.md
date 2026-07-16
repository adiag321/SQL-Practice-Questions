## Signup Activation Rate

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Aggregation · Conditional Sum |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/signup-activation-rate |

---

#### Problem Statement

Calculate the **signup activation rate**: the percentage of emails that resulted in a confirmed signup. Return the rate rounded to two decimal places.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS emails;
DROP TABLE IF EXISTS texts;

CREATE TABLE emails (
    email_id INTEGER PRIMARY KEY,
    email_address VARCHAR(100)
);

CREATE TABLE texts (
    email_id INTEGER,
    signup_action VARCHAR(20)   -- 'Confirmed' or other
);

INSERT INTO emails (email_id, email_address) VALUES
(1, 'alice@example.com'),
(2, 'bob@example.com'),
(3, 'carol@example.com'),
(4, 'dave@example.com');

INSERT INTO texts (email_id, signup_action) VALUES
(1, 'Confirmed'),
(2, 'Pending'),
(3, 'Confirmed'),
(4, 'Pending');
```

---

#### Solution

```sql
SELECT ROUND(
       (
           SUM(CASE WHEN signup_action = 'Confirmed' THEN 1.0 ELSE 0.0 END) /
           COUNT(emails.email_id)
       ) * 100,
       2) AS activation_rate
FROM texts
LEFT JOIN emails USING(email_id);
```

---

#### Sample Output

| activation_rate |
|-----------------|
| 50.00 |
