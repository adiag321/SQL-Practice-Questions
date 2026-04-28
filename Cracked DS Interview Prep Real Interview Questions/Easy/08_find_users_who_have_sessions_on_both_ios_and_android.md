## Find users who have sessions on both iOS and Android

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · Having |
| **Companies** | Meta · Spotify |

---

#### Problem Statement

Find users who have sessions on both iOS and Android.

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
-- Users on both iOS and Android
select distinct user_id,
count(*)
from (
  select distinct user_id, platform
  from sessions
  where platform = 'ios'
  union all
  select distinct user_id, platform
  from sessions
  where platform = 'android'
  )
group by 1
having count(*)= 2
order by user_id
```

---

#### Sample Output

| user_id | count(*) |
|---------|----------|
| 5       | 2        |
