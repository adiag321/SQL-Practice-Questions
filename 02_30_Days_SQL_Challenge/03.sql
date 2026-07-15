-- Day 03/30 days SQL challenge
-- Leetcode problem LeetCode SQL Premium Problem 2853: 'Highest Salary Difference'

/*
Write an SQL query to calculate the difference between the highest salaries in the marketing and engineering department. 
Output the absolute difference in salaries.
*/

-- DDL for Salaries table
CREATE TABLE Salaries (
emp_name VARCHAR(50),
department VARCHAR(50),
salary INT,
PRIMARY KEY (emp_name, department)
);
INSERT INTO Salaries (emp_name, department, salary) VALUES
('Kathy', 'Engineering', 50000),
('Roy', 'Marketing', 30000),
('Charles', 'Engineering', 45000),
('Jack', 'Engineering', 85000),
('Benjamin', 'Marketing', 34000),
('Anthony', 'Marketing', 42000),
('Edward', 'Engineering', 102000),
('Terry', 'Engineering', 44000),
('Evelyn', 'Marketing', 53000),
('Arthur', 'Engineering', 32000);

SELECT * FROM Salaries;

-- ----------------------------------------------
-- My solution
-- ----------------------------------------------
-- Solution 1: Simple aggregation with conditional MAX
SELECT
	ABS(MAX(CASE WHEN department = 'Marketing' THEN salary END) -
	MAX(CASE WHEN department = 'Engineering' THEN salary END)) as salary_diff
FROM Salaries;
	
-- Solution 2: Using CTE and Window Function
with sal_diff as (
  select
department,
salary,
rank() over(partition by department order by salary desc) as rnk
from Salaries
where department in ('Engineering', 'Marketing')
 )

select
abs(max(case when department = 'Engineering' then salary else 0 end) - 
max(case when department = 'Marketing' then salary else 0 end)) as salary_diff
from sal_diff
where rnk = 1;