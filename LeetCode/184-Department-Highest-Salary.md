# 184. Department Highest Salary

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Joins · Data Aggregation · Window Functions |
| **Companies** | Various |

Link: [LeetCode - 184. Department Highest Salary](https://leetcode.com/problems/department-highest-salary/)
---

## Problem Statement

Write a solution to find employees who have the highest salary in each of the departments. Return the result table in any order.

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
    name VARCHAR(50) NOT NULL
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
    (1, 'Joe', 70000, 1),
    (2, 'Jim', 90000, 1),
    (3, 'Henry', 80000, 2),
    (4, 'Sam', 60000, 2),
    (5, 'Max', 90000, 1);
```

## Solution

````sql
-- Method 1: Using Subquery with IN clause
SELECT 
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d ON e.departmentId = d.id
WHERE (e.departmentId, e.salary) IN (
    SELECT departmentId, MAX(salary)
    FROM Employee
    GROUP BY departmentId
);

-- Method 2: Using Window Function
WITH highest_sal AS (
    SELECT
        dept.name AS Department,
        emp.name AS Employee,
        emp.salary,
        DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS rnk
    FROM Employee AS emp
    JOIN Department AS dept ON emp.departmentId = dept.id
)
SELECT
    Department,
    Employee,
    Salary
FROM highest_sal
WHERE rnk = 1;
````

## Sample Output

| Department | Employee | Salary |
|------------|----------|--------|
| IT | Jim | 90000 |
| IT | Max | 90000 |
| Sales | Henry | 80000 |
