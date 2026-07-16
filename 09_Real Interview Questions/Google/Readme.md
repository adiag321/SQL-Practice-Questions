# Google SQL Interview Questions

## Table Schema

### employees Table

| Column Name | Type    |
|-------------|---------|
| employee    | varchar |
| department  | varchar |
| salary      | int     |

### user_logs Table

| Column Name | Type      |
|-------------|-----------|
| user_id     | int       |
| action      | varchar   |
| log_date    | date      |

### employee_salaries Table

| Column Name | Type |
|-------------|------|
| employee_id | int  |
| year        | int  |
| salary      | int  |

### user_actions Table

| Column Name | Type      |
|-------------|-----------|
| user_id     | int       |
| action      | varchar   |
| timestamp   | timestamp |

## Schema Setup

```sql
CREATE TABLE employees (
    employee VARCHAR(100),
    department VARCHAR(100),
    salary INT
);

INSERT INTO employees (employee, department, salary) VALUES
('Alice', 'Engineering', 120000),
('Bob', 'Engineering', 110000),
('Charlie', 'Engineering', 150000),
('David', 'Marketing', 90000),
('Emma', 'Marketing', 95000),
('Frank', 'Sales', 80000);

CREATE TABLE user_logs (
    user_id INT,
    action VARCHAR(50),
    log_date DATE
);

INSERT INTO user_logs (user_id, action, log_date) VALUES
(101, 'login', '2026-03-15'),
(102, 'login', '2026-03-14'),
(101, 'logout', '2026-03-15'),
(103, 'login', '2026-03-12'),
(104, 'login', '2026-03-08'),
(102, 'login', '2026-03-16');

CREATE TABLE employee_salaries (
    employee_id INT,
    year INT,
    salary INT
);

INSERT INTO employee_salaries (employee_id, year, salary) VALUES
(1, 2021, 50000),
(1, 2022, 55000),
(1, 2023, 60000),
(2, 2021, 70000),
(2, 2022, 65000),
(2, 2023, 75000),
(3, 2021, 80000),
(3, 2022, 85000),
(3, 2023, 82000);

CREATE TABLE user_actions (
    user_id INT,
    action VARCHAR(50),
    timestamp TIMESTAMP
);

INSERT INTO user_actions (user_id, action, timestamp) VALUES
(101, 'login', '2026-03-16 08:00:00'),
(101, 'logout', '2026-03-16 08:15:00'),
(102, 'login', '2026-03-16 09:00:00'),
(102, 'logout', '2026-03-16 09:45:00');
```

---

## Question 1: Find the Median of Salaries

### Problem Description

How to calculate the median salary in a table.

### Solution

```sql
SELECT AVG(salary) AS median_salary
FROM (
    SELECT salary
    FROM employees
    ORDER BY salary
    LIMIT 2 - (SELECT COUNT(*) FROM employees) % 2
    OFFSET (SELECT (COUNT(*) - 1) / 2 FROM employees)
) AS median;
```

### Expected Output

| median_salary |
|---------------|
| 102500.0000   |

---

## Question 2: Employees with the Highest Salary in Each Department

### Problem Description

Query to find employees with the highest salary department-wise.

### Solution

```sql
SELECT department, employee, salary
FROM (
    SELECT department, employee, salary,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
) AS ranked
WHERE rnk = 1;
```

### Expected Output

| department  | employee | salary |
|-------------|----------|--------|
| Engineering | Charlie  | 150000 |
| Marketing   | Emma     | 95000  |
| Sales       | Frank    | 80000  |

---

## Question 3: Find All Active Users for the Last 7 Days

### Problem Description

How to find distinct users who logged in over the past 7 days.

### Solution

```sql
SELECT COUNT(DISTINCT user_id) AS active_users
FROM user_logs
WHERE action = 'login'
  AND log_date >= CURRENT_DATE - INTERVAL '7 days';
```

### Expected Output

*Assumed `CURRENT_DATE` is `2026-03-16`:*

| active_users |
|--------------|
| 3            |

---

## Question 4: Nth Highest Salary

### Problem Description

Find the Nth highest salary in a table.

### Solution

```sql
WITH salary_ranking AS (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT salary
FROM salary_ranking
WHERE rnk = N;
```

### Expected Output

*Assumed parameters: `N = 2`:*

| salary |
|--------|
| 120000 |

---

## Question 5: Find Consecutive Increases in Salary

### Problem Description

Identify employees whose salary has increased for 3 consecutive years.

### Solution

```sql
WITH ranked_salaries AS (
    SELECT employee_id, year, salary,
           LAG(salary, 1) OVER (PARTITION BY employee_id ORDER BY year) AS prev_salary_1,
           LAG(salary, 2) OVER (PARTITION BY employee_id ORDER BY year) AS prev_salary_2
    FROM employee_salaries
)
SELECT employee_id
FROM ranked_salaries
WHERE salary > prev_salary_1 AND prev_salary_1 > prev_salary_2;
```

### Expected Output

| employee_id |
|-------------|
| 1           |

---

## Question 6: Average Time Between Two Actions

### Problem Description

Calculate the average time (in minutes) between two actions (`login` and `logout`).

### Solution

```sql
WITH login_logout AS (
    SELECT user_id,
           MIN(CASE WHEN action = 'login' THEN timestamp END) AS login_time,
           MIN(CASE WHEN action = 'logout' THEN timestamp END) AS logout_time
    FROM user_actions
    WHERE action IN ('login', 'logout')
    GROUP BY user_id
)
SELECT AVG(EXTRACT(EPOCH FROM (logout_time - login_time))) / 60 AS avg_minutes
FROM login_logout;
```

### Expected Output

| avg_minutes |
|-------------|
| 30.0000     |