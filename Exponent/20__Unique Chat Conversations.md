## Unique Chat Conversations

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/practice/prepare/unique-chat-conversations |

---

#### Problem Statement

WhatsApp is a popular messaging platform that allows users to send and receive text messages, voice notes, and multimedia messages in real-time. Users can engage in one-on-one chats or group chats, and every message sent has a unique identifier.

You are given a table `messenger_sends` with the following schema:
*   `date` (date): The date the message was sent.
*   `ts` (timestamp): The timestamp of when the message was sent.
*   `sender_id` (integer): The unique identifier for the sender of the message.
*   `receiver_id` (integer): The unique identifier for the receiver of the message.
*   `message_id` (integer): A unique identifier for each message.

Given that a conversation thread between two users A and B remains the same whether A messages B or B messages A, write a SQL query to determine how many unique conversation (`unique_conversations`) threads are present in the `messenger_sends` table.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS messenger_sends;

CREATE TABLE messenger_sends (
    date DATE,
    ts TIMESTAMP,
    sender_id INTEGER,
    receiver_id INTEGER,
    message_id INTEGER PRIMARY KEY
);

INSERT INTO messenger_sends (date, ts, sender_id, receiver_id, message_id) VALUES
('2024-06-01', '2024-06-01 10:00:00', 1, 2, 1001),
('2024-06-01', '2024-06-01 10:02:00', 2, 1, 1002),
('2024-06-01', '2024-06-01 10:05:00', 1, 3, 1003),
('2024-06-01', '2024-06-01 10:10:00', 3, 4, 1004),
('2024-06-01', '2024-06-01 10:12:00', 4, 3, 1005),
('2024-06-01', '2024-06-01 10:15:00', 2, 3, 1006);
```

---

#### Solution

```sql
WITH messages AS (
    SELECT
        sender_id AS user1,
        receiver_id AS user2
    FROM messenger_sends
    UNION
    SELECT
        receiver_id AS user1,
        sender_id AS user2
    FROM messenger_sends
)
SELECT COUNT(*) AS unique_conversations
FROM messages
WHERE user1 < user2;
```

---

#### Sample Output

| unique_conversations |
|----------------------|
| 4                    |
