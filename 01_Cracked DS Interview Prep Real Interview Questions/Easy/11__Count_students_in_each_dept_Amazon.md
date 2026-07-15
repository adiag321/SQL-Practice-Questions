## Count students in each department. Show departments with zero students too.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | LEFT JOIN · COUNT · GROUP BY |
| **Companies** | Amazon |

---

#### Problem Statement

Count the number of students in each department. The result must include departments that currently have zero students. Sort the results by the number of students descending, then alphabetically by department name.

---

#### Schema Setup

```sql
-- 1. Create Tables
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    dept_id INT
);
```
-- 2. Insert Sample Data
```sql
INSERT INTO Department (dept_id, dept_name) VALUES
(1, 'Engineering'),
(2, 'Science'),
(3, 'Law'),      -- Department with 0 students
(4, 'Arts');     -- Department with 0 students

INSERT INTO Student (student_id, student_name, dept_id) VALUES
(101, 'Alice', 1),
(102, 'Bob', 1),
(103, 'Charlie', 1),
(104, 'David', 2),
(105, 'Eve', 2);
```

### Solution

```sql
SELECT d.dept_name, COUNT(s.student_id) AS student_count
FROM Department d
LEFT JOIN Student s ON d.dept_id = s.dept_id
GROUP BY d.dept_name
ORDER BY student_count DESC, d.dept_name ASC;
```

### Explanation

* LEFT JOIN: Ensures that all records from the left table (Department) are included in the result, even if there are no matching records in the right table (Student). This is how departments with zero students are retained.

* COUNT(student_id): Only counts non-null values in the student_id column. For departments with no students, the LEFT JOIN produces NULL for student_id, so the count evaluates to 0.

* COUNT(*) vs COUNT(column): Using COUNT(*) here would be a mistake. It counts rows, meaning an empty department would incorrectly return 1 because the row itself exists from the Department table side of the join.

* ORDER BY: Sorts by student_number DESC to show the largest departments first, with Department.dept_name acting as an alphabetical tiebreaker.

### Common Mistake:

Using an INNER JOIN instead of a LEFT JOIN would immediately filter out any departments that do not have a matching student record, completely defeating the purpose of the question. The LEFT JOIN + COUNT(right_table_column) pattern is the fundamental way to solve "show all categories even if empty" reporting problems.