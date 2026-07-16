# Employee Salaries

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Joins · Data Aggregation · HAVING Clause |
| **Companies** | Various |

Link: [Interview Query - Employee Salaries](https://www.interviewquery.com/questions/employee-salaries)
---

## Problem Statement

Given an `employees` and `departments` table, select the top 3 departments with at least ten employees and rank them according to the percentage of their employees making over 100K in salary.

---

## Tables Used

**`employees`**

| Column | Type |
|--------|------|
| id | INTEGER |
| first_name | VARCHAR |
| last_name | VARCHAR |
| salary | INTEGER |
| department_id | INTEGER |

**`departments`**

| Column | Type |
|--------|------|
| id | INTEGER |
| name | VARCHAR |

```sql
CREATE TABLE departments (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary INTEGER,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
```
---

## Approach

1. **Join Tables**: Connect employees with departments using `department_id`
2. **Group by Department**: Use `GROUP BY d.name` to aggregate data per department
3. **Calculate Percentage**: Use `AVG(CASE WHEN e.salary > 100000 THEN 1 ELSE 0 END)` to calculate the percentage of employees earning over 100K
   - This converts boolean conditions to 1 (true) or 0 (false), then averages to get the percentage
4. **Filter with HAVING**: Only include departments with at least 10 employees using `HAVING COUNT(*) >= 10`
5. **Sort and Limit**: Order by percentage in descending order and return only the top 3


---

## Solution

````sql
SELECT 
    AVG(CASE WHEN e.salary > 100000 THEN 1 ELSE 0 END) AS percentage_over_100k,
    d.name AS department_name,
    COUNT(*) AS number_of_employees
FROM employees AS e
JOIN departments AS d 
    ON e.department_id = d.id
GROUP BY d.name
HAVING COUNT(*) >= 10
ORDER BY percentage_over_100k DESC
LIMIT 3;
````

## Output Format

| Column | Type |
|--------|------|
| percentage_over_100k | FLOAT |
| department_name | VARCHAR |
| number_of_employees | INTEGER |
