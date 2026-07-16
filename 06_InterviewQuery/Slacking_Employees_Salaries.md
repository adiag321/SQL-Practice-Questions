# Slacking Employees Salaries

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Joins · Data Aggregation · Subqueries |
| **Companies** | Various |

Link: [Interview Query - Slacking Employees Salaries](https://www.interviewquery.com/questions/slacking-employees-salaries)
---

## Problem Statement

Suppose your company needs to cut costs due to an economic downturn. During a coffee break, you hear a rumor that a lot of money goes to employees who don't do their work, and you decide to find out if the rumor is true.

Given two tables: employees and projects, find the sum of the salaries of all the employees who didn't complete any of their projects.

**Clarification:**
- We will consider a project unfinished if it has no end date (its End_dt is NULL).
- Given this, we'll say an employee didn't finish any of their projects when:
  - They were assigned at least one project.
  - None of their projects have an End_dt.

---

## Tables Used

**`employees`**

| Column | Type |
|--------|------|
| id | INTEGER |
| salary | FLOAT |

**`projects`**

| Column | Type |
|--------|------|
| employee_id | INTEGER |
| project_id | INTEGER |
| Start_dt | DATETIME |
| End_dt | DATETIME |

```sql
CREATE TABLE employees (
  id INTEGER PRIMARY KEY,
  salary FLOAT
);

CREATE TABLE projects (
  employee_id INTEGER,
  project_id INTEGER,
  Start_dt DATETIME,
  End_dt DATETIME,
  FOREIGN KEY (employee_id) REFERENCES employees(id)
);

INSERT INTO employees (id, salary) VALUES
(1, 50000), (2, 60000), (3, 55000), (6, 51115), (7, 45000);

INSERT INTO projects (employee_id, project_id, Start_dt, End_dt) VALUES
(1, 300, '2022-01-01', '2022-03-31'),
(1, 301, '2022-04-01', '2022-06-30'),
(2, 302, '2022-07-01', '2022-09-30'),
(2, 303, '2022-10-01', NULL),
(3, 304, '2022-01-01', NULL),          -- Slacking (only one project, unfinished)
(6, 305, '2022-04-01', NULL),          -- Slacking (unfinished)
(6, 306, '2022-07-01', NULL),          -- Slacking (unfinished)
(7, 307, '2022-10-01', '2022-12-31');
```

## Solution

````sql
-- solution 1
SELECT 
    SUM(salary) AS total_slack_salary
FROM employees
WHERE id IN (
    SELECT employee_id
    FROM projects
    GROUP BY employee_id
    -- COUNT(End_dt) counts only non-null values
    -- HAVING COUNT(project_id) > 0 ensures they have at least one project
    HAVING COUNT(End_dt) = 0
);

-- solution 2 (using LEFT JOIN)
WITH emp_ids AS (
  SELECT
    p.employee_id,
    CASE WHEN SUM(CASE WHEN p.end_dt IS NULL THEN 1 ELSE 0 END) = 
              COUNT(DISTINCT p.project_id) THEN 1 ELSE 0 END AS cnt_val
  FROM employees AS e
  LEFT JOIN projects AS p
    ON e.id = p.employee_id
  GROUP BY 1
)
SELECT
  SUM(salary) AS total_slack_salary
FROM employees 
WHERE id IN (
  SELECT DISTINCT employee_id 
  FROM emp_ids 
  WHERE cnt_val = 1
);
````

## Sample Output

| total_slack_salary |
|--------------------|
| 106115 |
