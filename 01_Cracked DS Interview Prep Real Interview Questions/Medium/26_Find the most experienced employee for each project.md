## Find the most experienced employee for each project.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Subquery · JOIN · Window Functions |
| **Companies** | LeetCode |

---

#### Problem Statement

For each project, find the employee with the most experience years. If there is a tie, return all employees with the maximum experience for that project.

---

#### Create and Insert Statements

```sql
CREATE TABLE Employee (
    employee_id      INT PRIMARY KEY,
    name             TEXT,
    experience_years INT
);

CREATE TABLE Project (
    project_id  INT,
    employee_id INT,
    PRIMARY KEY (project_id, employee_id)
);

INSERT INTO Employee (employee_id, name, experience_years) VALUES
(1, 'Khaled',   3),
(2, 'Ali',      2),
(3, 'John',     3),    
(4, 'Doe',      2),
(5, 'Sarah',    5),   
(6, 'Mike',     1);   

INSERT INTO Project (project_id, employee_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 6),
(4, 4),
(4, 5);
```

---

#### Solution

```sql
-- Approach 1: Tuple IN subquery
SELECT project_id, employee_id
FROM Project
JOIN Employee USING (employee_id)
WHERE (project_id, experience_years) IN (
    SELECT project_id, MAX(experience_years)
    FROM Project
    JOIN Employee USING (employee_id)
    GROUP BY project_id
)
```

```sql
-- Approach 2: Window function (RANK)
SELECT project_id, employee_id
FROM (
    SELECT project_id, employee_id,
        RANK() OVER (PARTITION BY project_id ORDER BY experience_years DESC) AS rk
    FROM Project
    JOIN Employee USING (employee_id)
) t
WHERE rk = 1
```

---

#### Explanation

- **Approach 1:** The subquery finds the maximum experience per project. The outer query uses a tuple `IN` clause `(project_id, experience_years) IN (...)` to match rows with that composite key. This returns **all** employees tied for max experience.
- **Approach 2:** Uses `RANK()` partitioned by `project_id`, ordered by `experience_years DESC`. Filtering `rk = 1` returns all tied employees (since `RANK` gives the same rank to ties).
- The tuple `IN` clause is a powerful SQL pattern for matching on composite keys.

---

#### Sample Output

| project_id | employee_id |
|------------|-------------|
| 1          | 1           |
| 2          | 1           |

---