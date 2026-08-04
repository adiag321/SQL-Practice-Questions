## TV Show Watch Time

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/courses/data-science/sql-interviews/tv-show-watch-time |

---

#### Problem Statement

Disney+ is a streaming platform with multiple shows and millions of subscribers. The company wishes to identify their star customers, people who are using the platform more and more over time.

You are given the table `watch_time`:

```text
viewer_id | show_id | year | month | watch_hours
----------+---------+------+-------+------------
1         | 101     | 2022 | 1     | 50.5
1         | 101     | 2022 | 2     | 62.7
1         | 101     | 2022 | 3     | 75.2
1         | 101     | 2022 | 4     | 82.6
2         | 102     | 2022 | 1     | 30.0
2         | 102     | 2022 | 2     | 33.6
2         | 102     | 2022 | 3     | 42.1
2         | 102     | 2022 | 4     | 50.9
3         | 103     | 2022 | 1     | 20.5
3         | 103     | 2022 | 2     | 25.7
3         | 103     | 2022 | 3     | 23.0
3         | 103     | 2022 | 4     | 35.8
```

Write an SQL query to identify the viewers who have received a month-over-month increase in watch time of at least 3 months. In other words, you're looking for viewers who have consistently increased their watch time for a minimum of 3 consecutive months.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS watch_time;

CREATE TABLE watch_time (
    viewer_id INTEGER,
    show_id INTEGER,
    year INTEGER,
    month INTEGER,
    watch_hours DECIMAL(5,1)
);

INSERT INTO watch_time (viewer_id, show_id, year, month, watch_hours) VALUES
(1, 101, 2022, 1, 50.5),
(1, 101, 2022, 2, 62.7),
(1, 101, 2022, 3, 75.2),
(1, 101, 2022, 4, 82.6),
(2, 102, 2022, 1, 30.0),
(2, 102, 2022, 2, 33.6),
(2, 102, 2022, 3, 42.1),
(2, 102, 2022, 4, 50.9),
(3, 103, 2022, 1, 20.5),
(3, 103, 2022, 2, 25.7),
(3, 103, 2022, 3, 23.0),
(3, 103, 2022, 4, 35.8);
```

---

#### Solution

```sql
WITH lagged_watch_time AS (
    SELECT 
        viewer_id,
        year,
        month,
        watch_hours,
        LAG(watch_hours, 1) OVER(PARTITION BY viewer_id ORDER BY year, month) AS prev_watch_hours,
        LAG(watch_hours, 2) OVER(PARTITION BY viewer_id ORDER BY year, month) AS prev_prev_watch_hours
    FROM watch_time
)
SELECT DISTINCT viewer_id
FROM lagged_watch_time
WHERE watch_hours > prev_watch_hours AND prev_watch_hours > prev_prev_watch_hours;
```

---

#### Expected Outcome

| viewer_id |
|-----------|
| 1 |
| 2 |