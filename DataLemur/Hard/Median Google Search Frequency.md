## Median Google Search Frequency

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Tags** | CTE · PERCENTILE_CONT · GENERATE_SERIES |
| **Companies** | Google |
| **Link** | https://datalemur.com/questions/median-search-freq |

---

#### Problem Statement

Google's marketing team is studying how many searches a user makes per day. You are given a table that stores the number of searches (`searches`) alongside how many users performed that many searches (`num_users`).

Write a query to find the **median** number of searches made by a user, rounded to **1 decimal place**.

> **Hint:** Each row represents a group of `num_users` users who all made the same number of searches. Expand the data before computing the median.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS search_frequency;

CREATE TABLE search_frequency (
    searches  INTEGER,
    num_users INTEGER
);

INSERT INTO search_frequency (searches, num_users) VALUES
(1, 2),   -- expands to: 1, 1
(2, 2),   -- expands to: 2, 2
(3, 3),   -- expands to: 3, 3, 3
(4, 1);   -- expands to: 4
-- Full expanded list: 1, 1, 2, 2, 3, 3, 3, 4
-- Median = (2 + 3) / 2 = 2.5
```

---

#### Solution

```sql
WITH CTE AS (
    SELECT searches
    FROM search_frequency
    GROUP BY searches, GENERATE_SERIES(1, num_users)
)

SELECT
    ROUND(
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY searches)::DECIMAL,
        1
    ) AS median
FROM CTE;
```

---

#### Sample Output

| median |
|--------|
| 2.5    |
