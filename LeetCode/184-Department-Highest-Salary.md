# 184. Department Highest Salary

## Problem Description

Write a solution to find employees who have the highest salary in each of the departments.
Return the result table in any order.

Link: https://leetcode.com/problems/department-highest-salary/

## Table Schema

### Employee Table

| Column Name  | Type    |
|--------------|---------|
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |

- `id` is the primary key (column with unique values) for this table.
- `departmentId` is a foreign key (reference columns) of the ID from the Department table.
- Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.

### Department Table

| Column Name | Type    |
|-------------|---------|
| id          | int     |
| name        | varchar |

- `id` is the primary key (column with unique values) for this table.
- It is guaranteed that department name is not NULL.
- Each row of this table indicates the ID of a department and its name.

## Example

### Input

**Employee Table:**

| id | name  | salary | departmentId |
|----|-------|--------|--------------|
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |

**Department Table:**

| id | name  |
|----|-------|
| 1  | IT    |
| 2  | Sales |

### Output

| Department | Employee | Salary |
|------------|----------|--------|
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |

### Explanation

Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.

## Solution

```sql
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
```

### Alternative Solution (Using Window Function)

```sql
with highest_sal as (
    select
    dept.name as Department,
    emp.name as Employee,
    emp.salary,
    dense_rank() over(partition by departmentId order by salary desc) as rnk
    from Employee as emp
    join department as dept
    on emp.departmentId = dept.id
)

select
Department,
Employee,
Salary
from highest_sal
where rnk = 1;
```

## Approach

### Method 1: Subquery with IN clause
1. Find the maximum salary for each department using `GROUP BY departmentId`
2. Use the result as a subquery in the `WHERE` clause with tuple comparison `(departmentId, salary)`
3. Join with Department table to get department names
4. This handles multiple employees with the same highest salary in a department

### Method 2: Window Function (Alternative)
1. Use `RANK()` window function partitioned by department
2. Assign rank 1 to the highest salary in each department
3. Filter for `salary_rank = 1` to get all employees with the highest salary
4. Join with Department table for department names

Both methods handle ties correctly (multiple employees with the same max salary).

## Complexity

- **Time Complexity**: O(n + m) where n is the number of employees and m is the number of departments
  - Subquery method: One pass to find max salaries, one pass to filter
  - Window function method: One pass for ranking, one pass for filtering
- **Space Complexity**: O(n) for storing intermediate results