## IBM db2 Product Analytics

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | CTE · LEFT JOIN · UNION ALL · Histogram |
| **Companies** | IBM |
| **Link** | https://datalemur.com/questions/sql-ibm-db2-product-analytics |

---

#### Problem Statement

IBM is analyzing how their employees are utilizing the Db2 database by tracking the SQL queries executed by their employees. The objective is to generate data to populate a histogram showing the number of **unique queries** run by employees during **Q3 2023** (July – September). Also count employees who ran **zero** queries in that period.

Output: `unique_queries` (histogram bucket) and `employee_count`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS queries;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id INTEGER,
    full_name   VARCHAR(100),
    gender      VARCHAR(10)
);

CREATE TABLE queries (
    employee_id      INTEGER,
    query_id         INTEGER,
    query_starttime  TIMESTAMP,
    execution_time   INTEGER
);

INSERT INTO employees (employee_id, full_name, gender) VALUES
(1, 'Alice Johnson', 'Female'),
(2, 'Bob Smith',     'Male'),
(3, 'Carol White',   'Female'),
(4, 'Dave Brown',    'Male');

INSERT INTO queries (employee_id, query_id, query_starttime, execution_time) VALUES
-- Employee 1: 3 queries in Q3 2023
(1, 101, '2023-07-10 09:00:00', 30),
(1, 102, '2023-08-05 10:00:00', 15),
(1, 103, '2023-09-20 11:00:00', 45),
-- Employee 2: 1 query in Q3 2023
(2, 104, '2023-07-22 14:00:00', 20),
-- Employee 3: 0 queries in Q3 2023 (query outside window)
(3, 105, '2023-06-01 08:00:00', 10),
-- Employee 4: 0 queries in Q3 2023 (no queries at all)
(4, 106, '2022-11-01 08:00:00', 10);
-- Expected: 0 → 2 employees (3,4), 1 → 1 employee (2), 3 → 1 employee (1)
```

---

#### Solution

```sql
WITH emp_thrd_qrt AS (
    SELECT e.*, q.query_id, q.query_starttime
    FROM employees AS e
    LEFT JOIN queries AS q ON q.employee_id = e.employee_id
    WHERE EXTRACT(YEAR FROM query_starttime) = 2023
      AND EXTRACT(MONTH FROM query_starttime) BETWEEN 7 AND 9
),
emp_no_thrd_qrt AS (
    SELECT DISTINCT employee_id
    FROM employees
    WHERE employee_id NOT IN (SELECT employee_id FROM emp_thrd_qrt)
),
hist_rec AS (
    SELECT employee_id, COUNT(*) AS cnt
    FROM emp_thrd_qrt
    GROUP BY employee_id
    UNION ALL
    SELECT employee_id, 0 AS cnt
    FROM emp_no_thrd_qrt
)

SELECT cnt AS unique_queries, COUNT(*) AS employee_count
FROM hist_rec
GROUP BY 1
ORDER BY 1;
```

---

#### Sample Output

| unique_queries | employee_count |
|----------------|----------------|
| 0              | 2              |
| 1              | 1              |
| 3              | 1              |