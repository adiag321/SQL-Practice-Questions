## Calculate Test Scores

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Companies** | Google |
| **Link** | https://www.tryexponent.com/practice/prepare/calculate-test-scores |

---

#### Problem Statement

An organization has conducted SQL tests for all its backend developers. A developer could attempt a test multiple times. Write a query to print the `employee_id`, `employee_name`, and the `total_score` obtained by each developer.

A developer's `total_score` is the **sum of their maximum scores for all tests**. If the developer has attempted a single test multiple times, consider the maximum score of all the attempts for that test.

Order the results in descending `total_score`. In case more than one developer has the same total score, sort by ascending `employee_id`.

*Asked at Google and 4 other times.*

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS test_results;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS tests;

CREATE TABLE tests (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE test_results (
    id INT PRIMARY KEY,
    employee_id INT,
    test_id INT,
    score DECIMAL(5, 2)
);

INSERT INTO tests (id, name) VALUES
(1, 'SQL Basics'),
(2, 'SQL Joins'),
(3, 'SQL Window Functions');

INSERT INTO employees (id, name) VALUES
(101, 'Alice'),
(102, 'Bob'),
(103, 'Charlie');

-- Alice: attempts test 1 twice (scores 80, 90 → max 90), test 2 once (score 85)
-- total_score = 90 + 85 = 175
INSERT INTO test_results (id, employee_id, test_id, score) VALUES
(1, 101, 1, 80.00),
(2, 101, 1, 90.00),
(3, 101, 2, 85.00);

-- Bob: attempts test 1 once (score 70), test 2 twice (scores 60, 75 → max 75), test 3 once (score 95)
-- total_score = 70 + 75 + 95 = 240
INSERT INTO test_results (id, employee_id, test_id, score) VALUES
(4, 102, 1, 70.00),
(5, 102, 2, 60.00),
(6, 102, 2, 75.00),
(7, 102, 3, 95.00);

-- Charlie: attempts test 1 three times (scores 50, 65, 70 → max 70), test 3 once (score 88)
-- total_score = 70 + 88 = 158
INSERT INTO test_results (id, employee_id, test_id, score) VALUES
(8, 103, 1, 50.00),
(9, 103, 1, 65.00),
(10, 103, 1, 70.00),
(11, 103, 3, 88.00);
```

---

#### Solution

```sql
WITH max_scores AS (
    SELECT
        tr.employee_id,
        tr.test_id,
        e.name,
        MAX(tr.score) AS max_scr
    FROM test_results AS tr
    JOIN employees AS e ON tr.employee_id = e.id
    GROUP BY 1, 2, 3
)
SELECT
    employee_id,
    name AS employee_name,
    SUM(max_scr) AS total_score
FROM max_scores
GROUP BY 1, 2
ORDER BY 3 DESC;
```

---

#### Sample Output

| employee_id | employee_name | total_score |
|-------------|---------------|-------------|
| 102         | Bob           | 240.00      |
| 101         | Alice         | 175.00      |
| 103         | Charlie       | 158.00      |
