# 1875. Group Employees of the Same Salary

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Subqueries · Data Aggregation · Window Functions |
| **Companies** | Various |

Link: [LeetCode - 1875. Group Employees of the Same Salary](https://leetcode.com/problems/group-employees-of-the-same-salary/)
---

## Problem Statement

A company wants to divide the employees into teams such that all the members on each team have the **same salary**. The teams should follow these criteria:

- Each team should consist of **at least two** employees.
- All the employees on a team should have the **same salary**.
- All the employees of the same salary should be assigned to the same team.
- If the salary of an employee is unique, we **do not** assign this employee to any team.
- A team's ID is assigned based on the **rank of the team's salary** relative to the other teams' salaries. The team with the lowest salary gets `team_id = 1`.

Write a solution to get the `team_id` of each employee that is in a team. Return the result table ordered by `team_id` in ascending order. In case of a tie, order it by `employee_id` in ascending order.

---

## Tables Used

**`Employees`**

| Column | Type |
|--------|------|
| employee_id | INT |
| name | VARCHAR |
| salary | INT |

```sql
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT
);

INSERT INTO Employees (employee_id, name, salary)
VALUES
    (2, 'Meir', 3000),
    (3, 'Michael', 3000),
    (7, 'Adber', 7000),
    (8, 'Juan', 6000),
    (9, 'Alber', 7000),
    (11, 'Alice', 8000);
```

## Solution

````sql
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
````

## Sample Output

| employee_id | name | salary | team_id |
|-------------|------|--------|---------|
| 2 | Meir | 3000 | 1 |
| 3 | Michael | 3000 | 1 |
| 7 | Adber | 7000 | 2 |
| 9 | Alber | 7000 | 2 |

**Explanation:**
- Meir and Michael (salary 3000) form team 1 (lowest salary)
- Adber and Alber (salary 7000) form team 2
- Juan (salary 6000) and Alice (salary 8000) have unique salaries, so they are excluded
