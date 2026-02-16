# 185. Department Top Three Salaries

## Problem Description

A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the **top three unique** salaries for that department.

Write a solution to find the employees who are high earners in each of the departments.
Return the result table in any order.

Link: https://leetcode.com/problems/department-top-three-salaries/

## Table Schema

### Employee Table

| Column Name  | Type    |
|--------------|---------|
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |

- `id` is the primary key (column with unique values) for this table.
- `departmentId` is a foreign key (reference column) of the ID from the Department table.
- Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.

### Department Table

| Column Name | Type    |
|-------------|---------|
| id          | int     |
| name        | varchar |

- `id` is the primary key (column with unique values) for this table.
- Each row of this table indicates the ID of a department and its name.

## Example

### Input

**Employee Table:**

| id | name  | salary | departmentId |
|----|-------|--------|--------------|
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |

**Department Table:**

| id | name  |
|----|-------|
| 1  | IT    |
| 2  | Sales |

### Output

| Department | Employee | Salary |
|------------|----------|--------|
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |

### Explanation

In the IT department:
- Max earns the highest unique salary (90000)
- Both Joe and Randy earn the second-highest unique salary (85000)
- Will earns the third-highest unique salary (70000)
- Janet's salary (69000) is the fourth-highest, so she is not included

In the Sales department:
- Henry earns the highest unique salary (80000)
- Sam earns the second-highest unique salary (60000)
- There are only 2 unique salaries in Sales, so both employees are included

## Solution

```sql
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
```

## Approach

This problem requires finding employees with salaries in the **top 3 unique** values per department:

1. **Use DENSE_RANK() window function**: This is crucial because we need to rank by unique salary values without gaps
   - `DENSE_RANK()` assigns the same rank to tied salaries and continues with the next consecutive integer
   - Example: Salaries 90000, 85000, 85000, 70000 would get ranks 1, 2, 2, 3 (not 1, 2, 2, 4)

2. **Partition by departmentId**: Ensures ranking is done separately for each department
   - `PARTITION BY e.departmentId` creates separate ranking windows per department

3. **Order by salary DESC**: Highest salaries get rank 1
   - `ORDER BY e.salary DESC` within each partition

4. **Join with Department table**: Get department names instead of IDs
   - Join Employee with Department on `departmentId = id`

5. **Filter for top 3 ranks**: Use WHERE clause to get only ranks 1, 2, and 3
   - `WHERE salary_rank <= 3`

**Why DENSE_RANK() vs RANK()?**
- `RANK()`: Would create gaps (1, 1, 3, 4) - might miss the actual 3rd unique salary
- `DENSE_RANK()`: No gaps (1, 1, 2, 3) - correctly identifies top 3 unique salaries
- `ROW_NUMBER()`: Would break ties arbitrarily (1, 2, 3, 4) - incorrect for this problem

## Complexity

- **Time Complexity**: O(n log n) where n is the number of employees
  - Sorting within each partition for ranking
  - Join operation: O(n + m) where m is the number of departments
  
- **Space Complexity**: O(n) for storing the CTE results and window function calculations
