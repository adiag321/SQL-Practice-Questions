# SQL Scripts Window Function Part 1
> Practice Questions and Syntax Demonstrations based on the Employee Dataset.

---

## Database Setup

```sql
DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
    emp_ID INT,
    emp_NAME VARCHAR(50),
    DEPT_NAME VARCHAR(50),
    SALARY INT
);

INSERT INTO employee VALUES
(101, 'Mohan', 'Admin', 4000),
(102, 'Rajkumar', 'HR', 3000),
(103, 'Akbar', 'IT', 4000),
(104, 'Dorvin', 'Finance', 6500),
(105, 'Rohit', 'HR', 3000),
(106, 'Rajesh', 'Finance', 5000),
(107, 'Preet', 'HR', 7000),
(108, 'Maryam', 'Admin', 4000),
(109, 'Sanjay', 'IT', 6500),
(110, 'Vasudha', 'IT', 7000),
(111, 'Melinda', 'IT', 8000),
(112, 'Komal', 'IT', 10000),
(113, 'Gautham', 'Admin', 2000),
(114, 'Manisha', 'HR', 3000),
(115, 'Chandni', 'IT', 4500),
(116, 'Satya', 'Finance', 6500),
(117, 'Adarsh', 'HR', 3500),
(118, 'Tejaswi', 'Finance', 5500),
(119, 'Cory', 'HR', 8000),
(120, 'Monica', 'Admin', 5000),
(121, 'Rosalin', 'IT', 6000),
(122, 'Ibrahim', 'IT', 8000),
(123, 'Vikram', 'IT', 8000),
(124, 'Dheeraj', 'IT', 11000);
COMMIT;
```

---

## Question 1: Max Salary per Department (Using Window Aggregate Function)
Write a query to display all employee details along with the maximum salary of their department.

### Solution
```sql
SELECT e.*,
       MAX(salary) OVER(PARTITION BY dept_name) AS max_salary
FROM employee e;
```

### Expected Output (Sample)
| emp_id | emp_name | dept_name | salary | max_salary |
|---|---|---|---|---|
| 101 | Mohan | Admin | 4000 | 5000 |
| 120 | Monica | Admin | 5000 | 5000 |
| 104 | Dorvin | Finance | 6500 | 6500 |
| 102 | Rajkumar | HR | 3000 | 8000 |
| 124 | Dheeraj | IT | 11000 | 11000 |

---

## Question 2: First 2 Employees to Join Each Department
Fetch the first 2 employees from each department based on their employee ID.

### Solution
```sql
SELECT * 
FROM (
    SELECT e.*,
           ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY emp_id) AS rn
    FROM employee e
) x
WHERE x.rn < 3;
```

### Expected Output
| emp_id | emp_name | dept_name | salary | rn |
|---|---|---|---|---|
| 101 | Mohan | Admin | 4000 | 1 |
| 108 | Maryam | Admin | 4000 | 2 |
| 104 | Dorvin | Finance | 6500 | 1 |
| 106 | Rajesh | Finance | 5000 | 2 |
| 102 | Rajkumar | HR | 3000 | 1 |
| 105 | Rohit | HR | 3000 | 2 |
| 103 | Akbar | IT | 4000 | 1 |
| 109 | Sanjay | IT | 6500 | 2 |

---

## Question 3: Top 3 Earners in Each Department
Fetch the top 3 employees in each department earning the maximum salary.

### Solution
```sql
SELECT * 
FROM (
    SELECT e.*,
           RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) AS rnk
    FROM employee e
) x
WHERE x.rnk < 4;
```

### Expected Output
| emp_id | emp_name | dept_name | salary | rnk |
|---|---|---|---|---|
| 120 | Monica | Admin | 5000 | 1 |
| 101 | Mohan | Admin | 4000 | 2 |
| 108 | Maryam | Admin | 4000 | 2 |
| 104 | Dorvin | Finance | 6500 | 1 |
| 116 | Satya | Finance | 6500 | 1 |
| 118 | Tejaswi | Finance | 5500 | 3 |
| 119 | Cory | HR | 8000 | 1 |
| 107 | Preet | HR | 7000 | 2 |
| 117 | Adarsh | HR | 3500 | 3 |
| 124 | Dheeraj | IT | 11000 | 1 |
| 112 | Komal | IT | 10000 | 2 |
| 111 | Melinda | IT | 8000 | 3 |
| 122 | Ibrahim | IT | 8000 | 3 |
| 123 | Vikram | IT | 8000 | 3 |

---

## Question 4: Rank, Dense Rank, and Row Number Differences
Write a query to compare the output of `RANK()`, `DENSE_RANK()`, and `ROW_NUMBER()` for employee salaries within each department.

### Solution
```sql
SELECT e.*,
       RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) AS rnk,
       DENSE_RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) AS dense_rnk,
       ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY salary DESC) AS rn
FROM employee e;
```

### Expected Output (Sample: Admin Department)
| emp_id | emp_name | dept_name | salary | rnk | dense_rnk | rn |
|---|---|---|---|---|---|---|
| 120 | Monica | Admin | 5000 | 1 | 1 | 1 |
| 101 | Mohan | Admin | 4000 | 2 | 2 | 2 |
| 108 | Maryam | Admin | 4000 | 2 | 2 | 3 |
| 113 | Gautham | Admin | 2000 | 4 | 3 | 4 |

---

## Question 5: Compare Salary with Previous Employee (LAG)
Write a query to display all employee details along with the salary of the previous employee, and a status field (`sal_range`) indicating if the current employee's salary is higher, lower, or equal to the previous employee within their department.

### Solution
```sql
SELECT e.*,
       LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) AS prev_empl_sal,
       CASE 
           WHEN e.salary > LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) THEN 'Higher than previous employee'
           WHEN e.salary < LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) THEN 'Lower than previous employee'
           WHEN e.salary = LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) THEN 'Same than previous employee' 
       END AS sal_range
FROM employee e;
```

### Expected Output (Sample: Finance Department)
| emp_id | emp_name | dept_name | salary | prev_empl_sal | sal_range |
|---|---|---|---|---|---|
| 104 | Dorvin | Finance | 6500 | NULL | NULL |
| 106 | Rajesh | Finance | 5000 | 6500 | Lower than previous employee |
| 116 | Satya | Finance | 6500 | 5000 | Higher than previous employee |
| 118 | Tejaswi | Finance | 5500 | 6500 | Lower than previous employee |

---

## Question 6: LAG vs LEAD Demonstration
Write a query to display both the previous employee's salary and next employee's salary for each employee within their department.

### Solution
```sql
SELECT e.*,
       LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) AS prev_empl_sal,
       LEAD(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) AS next_empl_sal
FROM employee e;
```

### Expected Output (Sample: Finance Department)
| emp_id | emp_name | dept_name | salary | prev_empl_sal | next_empl_sal |
|---|---|---|---|---|---|
| 104 | Dorvin | Finance | 6500 | NULL | 5000 |
| 106 | Rajesh | Finance | 5000 | 6500 | 6500 |
| 116 | Satya | Finance | 6500 | 5000 | 5500 |
| 118 | Tejaswi | Finance | 5500 | 6500 | NULL |
