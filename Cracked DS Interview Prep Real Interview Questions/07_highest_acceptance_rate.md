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