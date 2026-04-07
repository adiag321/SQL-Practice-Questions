## Users on both iOS and Android

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | HAVING |
| **Companies** | Meta |

---

#### Problem Statement

Find users who are on both iOS and Android platforms.

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
select
user_id,
count(distinct platform) as cnt
from sessions
where platform in ('ios', 'android')
group by 1
having count(distinct platform) >= 2;