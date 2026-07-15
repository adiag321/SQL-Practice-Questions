## Article Views II: Find people who viewed more than one article on the same date.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | GROUP BY · HAVING · DISTINCT |
| **Companies** | Facebook |

---

#### Problem Statement

Find the people who viewed more than one distinct article on the same date. Sort the result by `id`.

---

#### Schema Setup

Since this table is not in the original schema, here are the `CREATE` and `INSERT` statements to test the query.

```sql
-- 1. Create Table
CREATE TABLE Views (
    article_id INT,
    author_id INT,
    viewer_id INT,
    view_date DATE
);
```

-- 2. Insert Sample Data
```sql
INSERT INTO Views (article_id, author_id, viewer_id, view_date) VALUES
(1, 3, 1, '2023-01-01'),
(2, 4, 1, '2023-01-01'), -- Viewer 1 viewed 2 distinct articles on 2023-01-01 (Include)
(3, 5, 2, '2023-01-02'),
(3, 5, 2, '2023-01-02'), -- Viewer 2 viewed the SAME article twice on 2023-01-02 (Exclude)
(4, 6, 3, '2023-01-03'),
(5, 7, 3, '2023-01-04'), -- Viewer 3 viewed 2 articles on DIFFERENT dates (Exclude)
(1, 3, 4, '2023-01-01'),
(5, 7, 4, '2023-01-01'); -- Viewer 4 viewed 2 distinct articles on 2023-01-01 (Include)
```
#### Solution

-- Approach 1: Using `HAVING` with `DISTINCT`
```sql
SELECT DISTINCT viewer_id AS id 
FROM Views
GROUP BY view_date, viewer_id
HAVING COUNT(DISTINCT article_id) > 1
ORDER BY id;
```

-- Approach 2: Subquery
```sql
SELECT id FROM (
  SELECT DISTINCT viewer_id AS id,
         COUNT(DISTINCT article_id) AS count_view
  FROM Views
  GROUP BY view_date, viewer_id
) sub
WHERE sub.count_view > 1
ORDER BY sub.id
```
