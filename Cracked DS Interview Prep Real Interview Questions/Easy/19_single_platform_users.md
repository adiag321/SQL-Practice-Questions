## Single-platform users.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | HAVING |
| **Companies** | Any |

---

#### Problem Statement

Find users who are only active on a single platform.

---

#### Table Used

**`sessions`**

| Column | Type |
|--------|------|
| session_id | INT (PK) |
| user_id | INT |
| session_date | DATE |
| duration_sec | INT |
| platform | TEXT |

---

#### Solution

```sql
-- Single platform users
select
*
from sessions
group by user_id
having count(distinct platform) = 1