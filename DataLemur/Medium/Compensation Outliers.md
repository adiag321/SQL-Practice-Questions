## Compensation Outliers

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | CTE · Aggregation · CASE WHEN |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/compensation-outliers |

---

#### Problem Statement

Identify employees whose salary is **overpaid** (salary ≥ 2 × average salary for their title) or **underpaid** (salary × 2 < average salary for their title). Return `employee_id`, `salary`, and a status label (`Overpaid` or `Underpaid`). Order results by `employee_id`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS employee_pay;

CREATE TABLE employee_pay (
    employee_id INTEGER,
    title       VARCHAR(50),
    salary      INTEGER
);

INSERT INTO employee_pay (employee_id, title, salary) VALUES
(1, 'Engineer', 120000),   -- avg ~ 100k, 2*avg=200k => underpaid
(2, 'Engineer', 210000),   -- overpaid (>=200k)
(3, 'Manager',  180000),   -- avg ~ 150k, 2*avg=300k => underpaid
(4, 'Manager',  320000),   -- overpaid
(5, 'Analyst',   90000);   -- avg ~ 90000, 2*avg=180k => underpaid
```

---

#### Solution

```sql
WITH ct AS (
    SELECT title,
           AVG(salary) AS av
    FROM employee_pay
    GROUP BY title
)
SELECT DISTINCT ep.employee_id,
                ep.salary,
                CASE WHEN ep.salary >= 2 * ct.av THEN 'Overpaid'
                     ELSE 'Underpaid' END AS status
FROM employee_pay ep
JOIN ct ON ep.title = ct.title
WHERE ep.salary >= 2 * ct.av
   OR ep.salary * 2 < ct.av
ORDER BY ep.employee_id;
```

---

#### Sample Output

| employee_id | salary | status |
|------------|--------|--------|
| 1 | 120000 | Underpaid |
| 2 | 210000 | Overpaid |
| 3 | 180000 | Underpaid |
| 4 | 320000 | Overpaid |
| 5 |  90000 | Underpaid |
