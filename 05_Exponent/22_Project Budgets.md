## Project Budgets

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/practice/prepare/project-budgets |

---

#### Problem Statement

Given the database with the schema shown below, write a query to fetch each project's ID, title, budget, total number of employees assigned to the project, and the sum of their salaries.

```text
employees                             projects
+---------------+---------+           +---------------+---------+
| id            | int     |<----+  +->| id            | int     |
| first_name    | varchar |     |  |  | title         | varchar |
| last_name     | varchar |     |  |  | start_date    | date    |
| salary        | int     |     |  |  | end_date      | date    |
| department_id | int     |--+  |  |  | budget        | int     |
+---------------+---------+  |  |  |  +---------------+---------+
                             |  |  |
departments                  |  |  |  employees_projects
+---------------+---------+  |  |  |  +---------------+---------+
| id            | int     |<-+  |  +--| project_id    | int     |
| name          | varchar |     +-----| employee_id   | int     |
+---------------+---------+           +---------------+---------+
```

#### Your query should return a result in the following format, ordered by highest to lowest total salary:
```text
id  | title   | budget | num_employees | total_salaries 
----+---------+--------+---------------+----------------
int | varchar | int    | int           | int
```

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS employees_projects;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    salary INTEGER,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE projects (
    id INTEGER PRIMARY KEY,
    title VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget INTEGER
);

CREATE TABLE employees_projects (
    project_id INTEGER,
    employee_id INTEGER,
    PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

INSERT INTO departments (id, name) VALUES
(1, 'Engineering'),
(2, 'Sales'),
(3, 'Marketing');

INSERT INTO employees (id, first_name, last_name, salary, department_id) VALUES
(1, 'John', 'Doe', 100000, 1),
(2, 'Jane', 'Smith', 120000, 1),
(3, 'Bob', 'Johnson', 95000, 1),
(4, 'Alice', 'Brown', 90000, 2),
(5, 'Charlie', 'Davis', 110000, 2),
(6, 'David', 'Wilson', 85000, 3),
(7, 'Eva', 'Martinez', 85000, 3);

INSERT INTO projects (id, title, start_date, end_date, budget) VALUES
(1, 'Project Alpha', '2024-01-01', '2024-06-30', 50000),
(2, 'Project Beta', '2024-03-01', '2024-12-31', 100000);

INSERT INTO employees_projects (project_id, employee_id) VALUES
(1, 1),
(1, 2),
(2, 4),
(2, 5);
```

---

#### Solution

```sql
SELECT
    p.id AS id,
    p.title,
    p.budget,
    COUNT(e.id) AS num_employees,
    SUM(e.salary) AS total_salaries
FROM employees_projects AS ep
JOIN projects AS p
    ON p.id = ep.project_id
JOIN employees AS e
    ON ep.employee_id = e.id
GROUP BY 1, 2, 3
ORDER BY total_salaries DESC;
```

---

#### Expected Outcome

| id | title | budget | num_employees | total_salaries |
|----|-------|--------|---------------|----------------|
| 1 | Project Alpha | 50000 | 2 | 220000 |
| 2 | Project Beta | 100000 | 2 | 200000 |
