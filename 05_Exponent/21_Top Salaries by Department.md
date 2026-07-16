## Top Salaries by Department

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Hard |
| **Companies** | Tesla |
| **Link** | https://www.tryexponent.com/practice/prepare/top-salaries-by-department |

---

#### Problem Statement

Given the database with the schema shown below, write a SQL query to fetch the top earning employee by department, ordered by department name.

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

#### Your query should return a result in the following format:
```text
department_name | employee_id | first_name | last_name | salary 
----------------+-------------+------------+-----------+--------
varchar         | int         | varchar    | varchar   | int
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
WITH salary_rnks AS (
    SELECT
        e.*,
        d.name,
        RANK() OVER (PARTITION BY d.name ORDER BY e.salary DESC) AS rnk
    FROM employees AS e
    JOIN departments AS d ON e.department_id = d.id
)
SELECT
    name AS department_name,
    id AS employee_id,
    first_name,
    last_name,
    salary
FROM salary_rnks
WHERE rnk = 1
ORDER BY 1;
```

---

#### Sample Output

| department_name | employee_id | first_name | last_name | salary |
|-----------------|-------------|------------|-----------|--------|
| Engineering     | 2           | Jane       | Smith     | 120000 |
| Marketing       | 6           | David      | Wilson    | 85000  |
| Marketing       | 7           | Eva        | Martinez  | 85000  |
| Sales           | 5           | Charlie    | Davis     | 110000 |