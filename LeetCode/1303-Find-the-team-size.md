# 1303. Find the Team Size

## Problem Description

Write a solution to find the team size of each of the employees.
Return the result table in any order.

Link: https://leetcode.com/problems/find-the-team-size/

## Table Schema

### Employee Table

| Column Name   | Type    |
|---------------|---------|
| employee_id   | int     |
| team_id       | int     |

- `employee_id` is the primary key (column with unique values) for this table.
- Each row of this table contains the ID of each employee and their respective team.

## Example

### Input

**Employee Table:**

| employee_id | team_id |
|-------------|---------|
| 1           | 8       |
| 2           | 8       |
| 3           | 8       |
| 4           | 7       |
| 5           | 9       |
| 6           | 9       |

### Output

| employee_id | team_size |
|-------------|-----------|
| 1           | 3         |
| 2           | 3         |
| 3           | 3         |
| 4           | 1         |
| 5           | 2         |
| 6           | 2         |

### Explanation

- Employees with Id 1, 2, 3 are part of a team with team_id = 8.
- Employee with Id 4 is part of a team with team_id = 7.
- Employees with Id 5, 6 are part of a team with team_id = 9.

## Solution

```sql
SELECT 
    employee_id,
    COUNT(employee_id) OVER (PARTITION BY team_id) AS team_size
FROM Employee
ORDER BY employee_id;
```

## Approach

This problem can be solved using a window function:
1. Use `COUNT(*) OVER (PARTITION BY team_id)` to count the number of employees in each team
2. The `PARTITION BY team_id` ensures we count employees within each team separately
3. Each employee gets assigned their team's size

## Complexity

- **Time Complexity**: O(n log n) due to the ordering operation
- **Space Complexity**: O(n) for storing the results
