## Laptop vs. Mobile Viewership

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · CASE WHEN · Filtering |
| **Companies** | New York Times |
| **Link** | https://datalemur.com/questions/laptop-mobile-viewership |

---

#### Problem Statement

Assume you're given the table on user viewership. Write a query to compare the **number of laptop views** vs. **mobile views** (tablet + phone). Output a single row with two columns: `laptop_views` and `mobile_views`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS viewership;

CREATE TABLE viewership (
    user_id     INTEGER,
    device_type VARCHAR(20),  -- 'laptop', 'tablet', 'phone'
    view_time   TIMESTAMP
);

INSERT INTO viewership (user_id, device_type, view_time) VALUES
(1, 'laptop',  '2022-01-01 10:00:00'),
(1, 'phone',   '2022-01-02 11:00:00'),
(2, 'laptop',  '2022-01-03 09:00:00'),
(3, 'tablet',  '2022-01-04 14:00:00'),
(4, 'phone',   '2022-01-05 16:00:00'),
(5, 'laptop',  '2022-01-06 08:00:00');
-- laptop_views = 3, mobile_views = 3
```

---

#### Solution

```sql
SELECT
    COUNT(CASE WHEN device_type = 'laptop' THEN 1 END) AS laptop_views,
    COUNT(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 END) AS mobile_views
FROM viewership;
```

---

#### Sample Output

| laptop_views | mobile_views |
|--------------|--------------|
| 3            | 3            |
