## Page With No Likes

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Subquery · NOT IN · EXCEPT |
| **Companies** | Facebook |
| **Link** | https://datalemur.com/questions/sql-page-with-no-likes |

---

#### Problem Statement

Given tables of pages and page likes, write a query to find all **page IDs that have received zero likes**. Output `page_id` ordered ascending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS pages;
DROP TABLE IF EXISTS page_likes;

CREATE TABLE pages (
    page_id   INTEGER,
    page_name VARCHAR(100)
);

CREATE TABLE page_likes (
    user_id   INTEGER,
    page_id   INTEGER,
    liked_date DATE
);

INSERT INTO pages (page_id, page_name) VALUES
(20001, 'SQL Solutions'),
(20045, 'Brain Exercises'),
(20701, 'Tips for Data Analysts');

INSERT INTO page_likes (user_id, page_id, liked_date) VALUES
(111, 20001, '2023-04-08'),
(121, 20045, '2023-03-12');
-- Page 20701 has no likes → should appear in output
```

---

#### Solution

```sql
SELECT page_id
FROM pages
WHERE page_id NOT IN (
    SELECT page_id FROM page_likes
)
ORDER BY page_id;
```

---

#### Alternative Solution

```sql
SELECT page_id
FROM pages
EXCEPT
SELECT page_id
FROM page_likes
ORDER BY page_id;
```

---

#### Sample Output

| page_id |
|---------|
| 20701   |
