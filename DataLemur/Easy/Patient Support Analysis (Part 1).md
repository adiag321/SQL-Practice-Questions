## Patient Support Analysis (Part 1)

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Subquery · HAVING · COUNT |
| **Companies** | UnitedHealth |
| **Link** | https://datalemur.com/questions/frequent-callers |

---

#### Problem Statement

Given a table of caller data for UnitedHealth's patient support line, write a query to find the **number of policy holders** who called **3 or more times** in the dataset.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS callers;

CREATE TABLE callers (
    policy_holder_id INTEGER,
    case_id          INTEGER,
    call_date        DATE,
    call_duration    INTEGER
);

INSERT INTO callers (policy_holder_id, case_id, call_date, call_duration) VALUES
-- Policy holder 1: 3 calls → counted
(1, 101, '2023-01-05', 300),
(1, 102, '2023-01-10', 450),
(1, 103, '2023-02-15', 200),
-- Policy holder 2: 4 calls → counted
(2, 201, '2023-01-07', 600),
(2, 202, '2023-01-20', 350),
(2, 203, '2023-02-01', 400),
(2, 204, '2023-03-10', 250),
-- Policy holder 3: 2 calls → excluded
(3, 301, '2023-01-15', 500),
(3, 302, '2023-02-20', 300);
-- Expected member_count = 2
```

---

#### Solution

```sql
SELECT COUNT(cnt) AS member_count
FROM (
    SELECT COUNT(policy_holder_id) AS cnt
    FROM callers
    GROUP BY policy_holder_id
    HAVING COUNT(policy_holder_id) >= 3
) AS TEMP;
```

---

#### Sample Output

| member_count |
|--------------|
| 2            |
