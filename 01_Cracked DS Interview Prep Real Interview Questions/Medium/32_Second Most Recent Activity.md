## Second Most Recent Activity per user.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · RANK · COUNT · Conditional Logic |
| **Companies** | LeetCode |

---

#### Problem Statement

Show each user's second most recent activity. If a user has only one activity, return that one instead.

---

#### Create and Insert Statements

```sql
CREATE TABLE UserActivity (
    username  TEXT,
    activity  TEXT,
    startDate DATE,
    endDate   DATE
);

INSERT INTO UserActivity (username, activity, startDate, endDate) VALUES
('Alice', 'Travel',  '2020-02-12', '2020-02-20'),
('Alice', 'Dancing', '2020-02-21', '2020-02-23'),
('Alice', 'Travel',  '2020-02-24', '2020-02-28'),
('Bob',   'Painting', '2020-01-01', '2020-01-02'),
('Charlie', 'Singing',  '2020-03-01', '2020-03-05'),
('Charlie', 'Cooking',  '2020-03-06', '2020-03-10'),
('Diana', 'Reading', '2020-01-10', '2020-01-15'),
('Diana', 'Running', '2020-02-01', '2020-02-10'),
('Diana', 'Hiking',  '2020-03-01', '2020-03-08'),
('Diana', 'Yoga',    '2020-04-01', '2020-04-05');
```

---

#### Solution

-- Solution 1
```sql
with cte1 as (select
username,
activity,
rank() over(partition by username order by endDate desc) as rnk
from UserActivity
),
cte2 as (select
*
from cte1
where rnk = 2
)
select * from cte2
union
select * from cte1
where username not in (select distinct username from cte2)
and rnk = 1
```

-- Solution 2
```sql
SELECT DISTINCT username, activity, startDate, endDate
FROM (
    SELECT u.*,
        RANK() OVER (PARTITION BY username ORDER BY startDate DESC) AS rnk,
        COUNT(activity) OVER (PARTITION BY username) AS num
    FROM UserActivity u
) t
WHERE (num <> 1 AND rnk = 2) OR (num = 1 AND rnk = 1)
```

---

#### Explanation

This uses a **conditional top-N** pattern — different selection logic based on group size.

- **Two window functions in one pass:**
  - `RANK()` partitioned by `username`, ordered by `startDate DESC`: most recent = 1, second = 2.
  - `COUNT(activity) OVER (PARTITION BY username)`: total activities per user.
- **`WHERE` clause handles two cases:**
  - Multiple activities (`num <> 1`): return rank 2 (second most recent).
  - Single activity (`num = 1`): return rank 1 (the only activity).
- `DISTINCT` is a safety net for potential duplicate rows.
- The trick is computing both the rank AND count in the same subquery using window functions.

---

#### Sample Output

| username | activity | startDate  | endDate    |
|----------|----------|------------|------------|
| Alice    | Dancing  | 2020-02-21 | 2020-02-23 |
| Bob      | Painting | 2020-01-01 | 2020-01-02 |

---