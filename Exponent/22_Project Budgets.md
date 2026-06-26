Project Budgets
Medium
Save
29

Question

Solution
Given the database with the schema shown below, write a query to fetch each project's ID, title, budget, total number of employees assigned to the project, and the sum of their salaries.

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
Your query should output a result in the following format, ordered by highest to lowest total salary:

id | title   | budget | num_employees | total_salaries 
----+---------+--------+---------------+----------------
int | varchar | int    | int           | int


# solution
-- postgresql
-- Write your query here

select
p.id as id,
p.title,
p.budget,
count(e.id) as num_employees,
sum(e.salary) as total_salaries
from employees_projects as ep
join projects as p
on p.id = ep.project_id
join employees as e
on ep.employee_id = e.id
group by 1,2,3
