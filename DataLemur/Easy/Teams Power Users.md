## Teams Power Users

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · COUNT DISTINCT · Date Functions |
| **Companies** | Microsoft |
| **Link** | https://datalemur.com/questions/teams-power-users |

---

#### Problem Statement

Write a query to identify the **top 2 power users** who sent the most messages in August 2022 on Microsoft Teams. Output `sender_id` and `message_count`, ordered by message count descending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS messages;

CREATE TABLE messages (
    message_id  INTEGER,
    sender_id   INTEGER,
    receiver_id INTEGER,
    content     VARCHAR(200),
    sent_date   TIMESTAMP
);

INSERT INTO messages (message_id, sender_id, receiver_id, content, sent_date) VALUES
-- Sender 101: 4 messages in Aug 2022
(1, 101, 202, 'Hello',       '2022-08-01 09:00:00'),
(2, 101, 303, 'Update',      '2022-08-05 10:00:00'),
(3, 101, 404, 'Meeting?',    '2022-08-12 11:00:00'),
(4, 101, 202, 'Follow up',   '2022-08-20 14:00:00'),
-- Sender 102: 3 messages in Aug 2022
(5, 102, 303, 'Hey',         '2022-08-02 09:30:00'),
(6, 102, 404, 'Question',    '2022-08-10 10:30:00'),
(7, 102, 101, 'Thanks',      '2022-08-25 15:00:00'),
-- Sender 103: 2 messages in Aug 2022
(8, 103, 101, 'Noted',       '2022-08-03 08:00:00'),
(9, 103, 202, 'Confirmed',   '2022-08-18 13:00:00'),
-- Message outside August → excluded
(10,101, 202, 'Old message', '2022-07-31 09:00:00');
```

---

#### Solution

```sql
SELECT sender_id, COUNT(DISTINCT receiver_id) AS message_count
FROM messages
WHERE DATE_PART('year', sent_date) = 2022
  AND DATE_PART('month', sent_date) = 8
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;
```

---

#### Sample Output

| sender_id | message_count |
|-----------|---------------|
| 101       | 3             |
| 102       | 3             |
