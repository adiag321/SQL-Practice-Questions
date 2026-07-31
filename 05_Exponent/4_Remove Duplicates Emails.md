## Remove Duplicate Emails

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Link** | https://www.tryexponent.com/practice/prepare/remove-duplicate-emails |

---

#### Problem Statement

Given a table `users` with columns `id` and `email`, write a SQL query to find the unique email addresses, keeping only the row with the smallest `id` for each distinct email (after normalizing with `LOWER` and `TRIM`). Email addresses should be considered the same if they are identical after converting to lowercase and trimming leading and trailing whitespace.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL
);

INSERT INTO users (id, email) VALUES
(1, 'user@example.com'),
(2, '  USER@example.com'),
(3, 'user@EXAMPLE.com '),
(4, 'john.doe@example.com'),
(5, 'JOHN.DOE@EXAMPLE.COM'),
(6, ' john.doe@example.com '),
(8, 'jane.smith@example.com'),
(9, 'JANE.smith@example.com  ');
```

---

#### Solution

```sql
SELECT
    id,
    LOWER(TRIM(email)) AS email
FROM users
WHERE id IN (
    SELECT MIN(id)
    FROM users
    GROUP BY LOWER(TRIM(email))
)
ORDER BY id;
```

---

#### Sample Output

| id | email                  |
|----|------------------------|
| 1  | user@example.com       |
| 4  | john.doe@example.com   |
| 8  | jane.smith@example.com |