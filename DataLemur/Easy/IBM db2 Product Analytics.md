## IBM db2 Product Analytics

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregate Functions · Joins |
| **Companies** | IBM |

---

#### Problem Statement

IBM is analyzing how their employees are utilizing the Db2 database by tracking the SQL queries executed by their employees. The objective is to generate data to populate a histogram that shows the number of unique queries run by employees during the third quarter of 2023 (July to September). Additionally, it should count the number of employees who did not run any queries during this period.
Display the number of unique queries as histogram categories, along with the count of employees who executed that number of unique queries.

Question Link: https://datalemur.com/questions/sql-ibm-db2-product-analytics
---

#### Tables Used

**`queries`**

| Column Name | Type | Description |
|-------------|------|-------------|
| employee_id | integer | The ID of the employee who executed the query. |
| query_id | integer | The unique identifier for each query (Primary Key). |
| query_starttime | datetime | The timestamp when the query started. |
| execution_time | integer | The duration of the query execution in seconds. |

**`employees`**

| Column Name | Type | Description |
|-------------|------|-------------|
| employee_id | integer | The ID of the employee who executed the query. |
| full_name | string | The full name of the employee. |
| gender | string | The gender of the employee. |

---

#### Solution

```sql
with emp_thrd_qrt as (SELECT 
e.*,
q.query_id,
q.query_starttime
FROM employees as e
left join queries as q
on q.employee_id = e.employee_id
where extract(year from query_starttime) = 2023
and extract(month from query_starttime) between 7 and 9
),
emp_no_thrd_qrt as (SELECT
distinct employee_id
FROM employees
where employee_id not in (select employee_id from emp_thrd_qrt)
),
hist_rec as (select 
employee_id,
count(*) as cnt
from emp_thrd_qrt
group by employee_id
union all 
SELECT
employee_id,
0 as cnt
from emp_no_thrd_qrt
)
select
cnt as unique_queries,
count(*) as employee_count
from hist_rec
group by 1
order by 1;
```

---

#### Expected Output

| unique_queries | employee_count |
|----------------|----------------|
| 0 | 	191 |
| 1	| 46 |
| 2	| 12 |
| 3	| 1 | 
| 4	| 0 |
    