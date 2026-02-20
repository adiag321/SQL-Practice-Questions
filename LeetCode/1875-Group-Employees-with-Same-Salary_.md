# 1875. Group Employees of the Same Salary -- IMPORTANT

## Problem Description

A company wants to divide the employees into teams such that all the members on each team have the **same salary**. The teams should follow these criteria:

- Each team should consist of **at least two** employees.
- All the employees on a team should have the **same salary**.
- All the employees of the same salary should be assigned to the same team.
- If the salary of an employee is unique, we **do not** assign this employee to any team.
- A team's ID is assigned based on the **rank of the team's salary** relative to the other teams' salaries. The team with the lowest salary gets `team_id = 1`. Note that the salaries for employees not on a team are **not included** in this ranking.

Write a solution to get the `team_id` of each employee that is in a team.
Return the result table ordered by `team_id` in **ascending** order. In case of a tie, order it by `employee_id` in **ascending** order.

Link: https://leetcode.com/problems/group-employees-of-the-same-salary/

## Table Schema

### Employees Table

| Column Name | Type    |
|-------------|---------|
| employee_id | int     |
| name        | varchar |
| salary      | int     |

- `employee_id` is the primary key (column with unique values) for this table.
- Each row of this table indicates the employee ID, employee name, and salary.

## Example

### Input

**Employees Table:**

| employee_id | name    | salary |
|-------------|---------|--------|
| 2           | Meir    | 3000   |
| 3           | Michael | 3000   |
| 7           | Adber   | 7000   |
| 8           | Juan    | 6000   |
| 9           | Alber   | 7000   |
| 11          | Alice   | 8000   |

### Output

| employee_id | name    | salary | team_id |
|-------------|---------|--------|---------|
| 2           | Meir    | 3000   | 1       |
| 3           | Michael | 3000   | 1       |
| 7           | Adber   | 7000   | 2       |
| 9           | Alber   | 7000   | 2       |

### Explanation

- Meir (employee_id = 2) and Michael (employee_id = 3) both have a salary of 3000. They are grouped into team 1 (lowest salary among teams).
- Adber (employee_id = 7) and Alber (employee_id = 9) both have a salary of 7000. They are grouped into team 2.
- Juan (employee_id = 8, salary = 6000) and Alice (employee_id = 11, salary = 8000) have unique salaries, so they are not assigned to any team and are excluded from the result.

## Solution

```sql
SELECT
    employee_id,
    name,
    salary,
    DENSE_RANK() OVER (ORDER BY salary) AS team_id
FROM Employees
WHERE salary IN (
    SELECT salary
    FROM Employees
    GROUP BY salary
    HAVING COUNT(*) >= 2
)
ORDER BY team_id, employee_id;
```

## Approach

This problem can be solved using a subquery with a window function:
1. **Identify valid team salaries**: Use a subquery with `GROUP BY salary` and `HAVING COUNT(*) >= 2` to find salaries shared by at least two employees.
2. **Filter employees**: Use `WHERE salary IN (...)` to keep only employees whose salary qualifies for a team.
3. **Assign team IDs**: Use `DENSE_RANK() OVER (ORDER BY salary)` to assign sequential team IDs based on salary rank. `DENSE_RANK` ensures no gaps in team numbering.
4. **Order results**: Sort by `team_id` ascending, then `employee_id` ascending for ties.

## Complexity

- **Time Complexity**: O(n log n) due to the sorting/ranking operation
- **Space Complexity**: O(n) for storing the results
