## Second Day Confirmation

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | JOIN · Date Arithmetic · Filtering |
| **Companies** | TikTok |
| **Link** | https://datalemur.com/questions/second-day-confirmation |

---

#### Problem Statement

Given tables of emails (signups) and texts (confirmation actions), write a query to find all users who confirmed their account **exactly on the day after** they signed up. Output `user_id`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS emails;
DROP TABLE IF EXISTS texts;

CREATE TABLE emails (
    email_id    INTEGER,
    user_id     INTEGER,
    signup_date DATE
);

CREATE TABLE texts (
    text_id       INTEGER,
    email_id      INTEGER,
    signup_action VARCHAR(20),  -- 'Confirmed' or 'Not confirmed'
    action_date   DATE
);

INSERT INTO emails (email_id, user_id, signup_date) VALUES
(125, 7771, '2022-06-14'),
(433, 1052, '2022-07-09'),
(601, 3346, '2022-08-01'),
(301, 8011, '2022-06-20');

INSERT INTO texts (text_id, email_id, signup_action, action_date) VALUES
(1, 125, 'Confirmed',     '2022-06-15'),  -- 1 day after → included
(2, 433, 'Confirmed',     '2022-07-11'),  -- 2 days after → excluded
(3, 601, 'Not confirmed', '2022-08-02'),  -- not confirmed → excluded
(4, 301, 'Confirmed',     '2022-06-21');  -- 1 day after → included
```

---

#### Solution

```sql
SELECT E.user_id
FROM texts T
INNER JOIN emails E ON E.email_id = T.email_id
WHERE T.signup_action = 'Confirmed'
  AND DATE(T.action_date) - DATE(E.signup_date) = 1;
```

---

#### Sample Output

| user_id |
|---------|
| 7771    |
| 8011    |
