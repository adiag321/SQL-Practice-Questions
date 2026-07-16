# 185. Department Top Three Salaries

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Tags** | Joins · Data Aggregation · Window Functions |
| **Companies** | Various |

Link: [LeetCode - 185. Department Top Three Salaries](https://leetcode.com/problems/department-top-three-salaries/)
---

## Problem Statement

A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the **top three unique** salaries for that department.

Write a solution to find the employees who are high earners in each of the departments. Return the result table in any order.

---

## Tables Used

**`Employee`**

| Column | Type |
|--------|------|
| id | INT |
| name | VARCHAR |
| salary | INT |
| departmentId | INT |

**`Department`**

| Column | Type |
|--------|------|
| id | INT |
| name | VARCHAR |

```sql
CREATE TABLE Department (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    departmentId INT,
    FOREIGN KEY (departmentId) REFERENCES Department(id)
);

INSERT INTO Department (id, name)
VALUES
    (1, 'IT'),
    (2, 'Sales');

INSERT INTO Employee (id, name, salary, departmentId)
VALUES
    (1, 'Joe', 85000, 1),
    (2, 'Henry', 80000, 2),
    (3, 'Sam', 60000, 2),
    (4, 'Max', 90000, 1),
    (5, 'Janet', 69000, 1),
    (6, 'Randy', 85000, 1),
    (7, 'Will', 70000, 1);
```

## Solution

````sql
WITH RankedSalaries AS (
    SELECT 
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS salary_rank
    FROM Employee e
    JOIN Department d ON e.departmentId = d.id
)
SELECT Department, Employee, Salary
FROM RankedSalaries
WHERE salary_rank <= 3;
````

## Sample Output

| Department | Employee | Salary |
|------------|----------|--------|
| IT | Max | 90000 |
| IT | Joe | 85000 |
| IT | Randy | 85000 |
| IT | Will | 70000 |
| Sales | Henry | 80000 |
| Sales | Sam | 60000 |

**Explanation:**
- **IT Department**: Max (90000), Joe & Randy (85000), Will (70000) - top 3 unique salaries
- **Sales Department**: Only 2 unique salaries (80000, 60000), so both employees are included
