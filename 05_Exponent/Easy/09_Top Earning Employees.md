## Top Earning Employees

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/top-earning-employees |

---

#### Problem Statement

Given the employee database with the schema shown below, write a query to fetch the top 3 earning employees, including their IDs, names, and salaries.

```text
employees
+---------------+---------+
| id            | int     |
| first_name    | varchar |
| last_name     | varchar |
| salary        | int     |
| department_id | int     |
+---------------+---------+
```

Your query should output a result in the following format:

```text
id  | first_name | last_name | salary
----+------------+-----------+--------
int | varchar    | varchar   | int
```

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary INTEGER,
    department_id INTEGER
);

INSERT INTO employees (id, first_name, last_name, salary, department_id) VALUES
(1, 'Alice', 'Smith', 90000, 1),
(2, 'Bob', 'Jones', 120000, 1),
(3, 'Carol', 'White', 105000, 2),
(4, 'Dave', 'Black', 80000, 2),
(5, 'Eve', 'Green', 130000, 3);
```

---

#### Solution

```sql
-- postgresql

SELECT
    id,
    first_name,
    last_name,
    salary
FROM employees
ORDER BY salary DESC
LIMIT 3;
```

---

#### Sample Output

| id | first_name | last_name | salary |
|----|-------------|------------|---------|
| 5  | Eve         | Green      | 130000  |
| 2  | Bob         | Jones      | 120000  |
| 3  | Carol       | White      | 105000  |
