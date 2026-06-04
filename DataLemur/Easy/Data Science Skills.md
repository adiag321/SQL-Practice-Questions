## Data Science Skills

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | GROUP BY · HAVING · Filtering |
| **Companies** | LinkedIn |
| **Link** | https://datalemur.com/questions/matching-skills |

---

#### Problem Statement

Given a candidates table with each row representing one skill a candidate has, write a query to find all candidates who have **all three** of the following skills: Python, Tableau, and PostgreSQL. Output their `candidate_id` ordered ascending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS candidates;

CREATE TABLE candidates (
    candidate_id INTEGER,
    skill        VARCHAR(50)
);

INSERT INTO candidates (candidate_id, skill) VALUES
-- Candidate 123: has all 3 required skills → included
(123, 'Python'),
(123, 'Tableau'),
(123, 'PostgreSQL'),
-- Candidate 234: missing PostgreSQL → excluded
(234, 'Python'),
(234, 'Tableau'),
(234, 'SQL'),
-- Candidate 345: has all 3 + extra → included
(345, 'Python'),
(345, 'Tableau'),
(345, 'PostgreSQL'),
(345, 'Java');
```

---

#### Solution

```sql
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(candidate_id) = 3
ORDER BY candidate_id;
```

---

#### Sample Output

| candidate_id |
|--------------|
| 123          |
| 345          |
