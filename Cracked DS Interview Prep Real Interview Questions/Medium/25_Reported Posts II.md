## Reported Posts II: Average daily percentage of spam posts removed.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Aggregation · LEFT JOIN · Subquery |
| **Companies** | Meta (Facebook) |

---

#### Problem Statement

Find the average daily percentage of spam posts that were removed. For each day, calculate the percentage of spam-reported posts that were actually removed, then average those daily percentages.

---

#### Create and Insert Statements

```sql
CREATE TABLE Actions (
    action_id   INT PRIMARY KEY,
    user_id     INT,
    post_id     INT,
    action_date DATE,
    action      TEXT,
    extra       TEXT
);

CREATE TABLE Removals (
    post_id     INT PRIMARY KEY,
    remove_date DATE
);

INSERT INTO Actions (action_id, user_id, post_id, action_date, action, extra) VALUES
(1,  1, 100, '2019-07-01', 'report', 'spam'),
(2,  2, 101, '2019-07-01', 'report', 'spam'),
(3,  3, 102, '2019-07-01', 'view',   NULL),
(4,  1, 103, '2019-07-02', 'report', 'spam'),
(5,  2, 104, '2019-07-02', 'report', 'spam'),
(6,  3, 105, '2019-07-02', 'report', NULL),
(7,  1, 106, '2019-07-03', 'report', 'spam'),
(8,  2, 106, '2019-07-03', 'report', 'spam'),
(9,  1, 107, '2019-07-04', 'report', 'spam'),
(10, 2, 108, '2019-07-04', 'report', 'spam');

INSERT INTO Removals (post_id, remove_date) VALUES
(100, '2019-07-01'),
(101, '2019-07-02'),
(103, '2019-07-02'),
(106, '2019-07-03');
```

---

#### Solution

-- Solution 1:
```sql
with spam_perc as (select
a.action_date,
round(sum(case when r.post_id is not NULL then 1 else 0 end)*100.00/count(*),2) as daily_pct
from Actions as a
left join Removals as r
on a.post_id = r.post_id     
where a.extra = 'spam'                   
group by 1
                   
)
select
avg(daily_pct) as average_daily_percent 
from spam_perc;
```

-- Solution 2:
```sql
SELECT ROUND(AVG(daily_pct), 2) AS average_daily_percent
FROM (
    SELECT action_date,
        COUNT(DISTINCT r.post_id) * 1.0 / COUNT(DISTINCT a.post_id) * 100 AS daily_pct
    FROM Actions a
    LEFT JOIN Removals r ON a.post_id = r.post_id
    WHERE a.extra = 'spam'
    GROUP BY a.action_date
) daily
```

---

#### Explanation

This query uses a two-step approach:

- **Inner query:** For each day, compute the percentage of spam-reported posts that were actually removed.
- **Outer query:** Average these daily percentages across all days.
- `LEFT JOIN` is used because not all reported posts get removed — unremoved posts will have `NULL` in `r.post_id`.
- `COUNT(DISTINCT r.post_id)` only counts non-NULL values (actually removed posts).
- `COUNT(DISTINCT a.post_id)` counts total spam reports that day.
- We filter for `extra = 'spam'` before grouping to only consider spam reports.
- We average **daily percentages**, not the overall percentage — these can differ (Simpson's Paradox).

---

#### Sample Output

| average_daily_percent |
|-----------------------|
| 62.50              |

---