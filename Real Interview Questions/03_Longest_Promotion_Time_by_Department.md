<p align ='center'>Longest Promotion Time by Department</p>

## Question: Find the longest promotion time by department
Calculate how long each employee waited for their FIRST promotion, count the wait time (promotion_date - hire_date), rank employees within each department by that wait time (longest first), and pick the #1 ranked employee per department.

Create and Insert Statements: 
```sql
CREATE TABLE Department (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE Employee (
    employee_id   INT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    salary        DECIMAL(10, 2),
    hire_date     DATE,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

CREATE TABLE Promotions (
    promotion_id   INT PRIMARY KEY,
    employee_id    INT NOT NULL,
    promotion_date DATE,
    new_salary     DECIMAL(10, 2),
    new_title      VARCHAR(100),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

INSERT INTO Department VALUES
(1, 'Marketing'),
(2, 'Engineering'),
(3, 'Data Science'),
(4, 'Healthcare Analytics');

INSERT INTO Employee VALUES
(101, 'Alice Johnson',  1, 70000.00, '2018-03-15'),
(102, 'Bob Smith',      1, 65000.00, '2019-07-01'),
(103, 'Carol White',    2, 85000.00, '2017-01-10'),
(104, 'David Brown',    2, 90000.00, '2020-06-20'),
(105, 'Eva Martinez',   3, 95000.00, '2016-11-05'),
(106, 'Frank Lee',      3, 88000.00, '2019-03-22'),
(107, 'Grace Kim',      4, 78000.00, '2018-09-14'),
(108, 'Henry Davis',    4, 72000.00, '2021-01-30');

INSERT INTO Promotions VALUES
(1001, 101, '2021-03-15', 85000.00,  'Senior Marketing Analyst'),   -- Alice: 3 years
(1002, 102, '2020-07-01', 78000.00,  'Marketing Specialist'),        -- Bob:   1 year
(1003, 103, '2019-01-10', 98000.00,  'Senior Engineer'),             -- Carol: 2 years
(1004, 104, '2023-06-20', 105000.00, 'Lead Engineer'),               -- David: 3 years
(1005, 105, '2018-11-05', 110000.00, 'Principal Data Scientist'),    -- Eva:   2 years
(1006, 106, '2022-03-22', 100000.00, 'Senior Data Scientist'),       -- Frank: 3 years
(1007, 107, '2021-09-14', 90000.00,  'Senior Health Analyst'),       -- Grace: 3 years
(1008, 108, '2023-01-30', 85000.00,  'Health Data Specialist');      -- Henry: 2 years
```

Solution: 
```sql
WITH promotion_wait AS (
    -- Step 1: Get each employee's FIRST promotion and calculate wait time
    SELECT
        e.employee_id,
        e.name,
        e.department_id,
        d.department_name,
        e.hire_date,
        MIN(p.promotion_date)                              AS first_promotion_date,
        DATEDIFF(MIN(p.promotion_date), e.hire_date)       AS days_to_promotion
    FROM Employee   e
    JOIN Department d ON e.department_id = d.department_id
    JOIN Promotions p ON e.employee_id   = p.employee_id
    GROUP BY
        e.employee_id, e.name, e.department_id,
        d.department_name, e.hire_date
),
ranked AS (
    -- Step 2: Rank employees within each department by longest wait
    SELECT
        *,
        RANK() OVER (
            PARTITION BY department_id
            ORDER BY days_to_promotion DESC
        ) AS rnk
    FROM promotion_wait
)
-- Step 3: Return only the top-ranked employee per department
SELECT
    department_name,
    name               AS employee_name,
    hire_date,
    first_promotion_date,
    days_to_promotion
FROM ranked
WHERE rnk = 1
ORDER BY department_name;
```