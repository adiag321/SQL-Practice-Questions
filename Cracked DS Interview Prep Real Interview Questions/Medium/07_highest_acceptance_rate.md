## User with highest friend request acceptance rate (min 2 sent)

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Aggregation · Edge Cases |
| **Companies** | Meta · LinkedIn |

---

#### Problem Statement

Calculate the friend request acceptance rate for users. Find the user with the highest friend request acceptance rate (minimum 2 sent).

---

#### Table Used

**`friend_requests`**

| Column | Type |
|--------|------|
| id | INT (PK) |
| sender_id | INT |
| receiver_id | INT |
| request_date | DATE |
| status | TEXT |

```sql
CREATE TABLE friend_requests (
  id INT PRIMARY KEY,
  sender_id INT,
  receiver_id INT,
  request_date DATE,
  status TEXT
);

INSERT INTO friend_requests (id, sender_id, receiver_id, request_date, status) VALUES
(1, 1, 2, '2024-01-10', 'pending'),
(2, 1, 3, '2024-01-11', 'accepted'),
(3, 2, 1, '2024-01-12', 'accepted'),
(4, 2, 3, '2024-01-13', 'accepted'),
(5, 2, 4, '2024-01-14', 'accepted'),
(6, 3, 4, '2024-01-15', 'rejected'),
(7, 5, 1, '2024-01-16', 'accepted'),
(8, 5, 2, '2024-01-17', 'accepted'),
(9, 5, 3, '2024-01-18', 'accepted'),
(10, 4, 1, '2024-01-19', 'pending');
```

---

#### Solution

```sql
-- Highest acceptance rate (min 2 sent)
SELECT 
sender_id, 
count(*) as total_req_sent,
sum(case when status = 'accepted' then 1 else 0 end) as accepted_req,
round(sum(case when status = 'accepted' then 1 else 0 end)*100.00/count(*) ,2) as accept_rate
from friend_requests
group by 1

```

---

#### Sample Output

| sender_id | total_req_sent | accepted_req | accept_rate |
|----------|----------------|--------------|-------------|
| 2        | 3              | 3            | 100.00      | 
| 5        | 3              | 3            | 100.00      | 

---