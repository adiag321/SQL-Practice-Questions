## Movie Rating: Top reviewer and top-rated movie in Feb 2020.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | UNION · Aggregation · ORDER BY tiebreak |
| **Companies** | LeetCode |

---

#### Problem Statement

Find two results in a single query using `UNION`:
1. The user who has rated the **most movies**. In case of a tie, return the user with the lexicographically smaller name.
2. The movie with the **highest average rating** in February 2020. In case of a tie, return the movie with the lexicographically smaller title.

---

#### Create and Insert Statements

```sql
CREATE TABLE Users_28 (
    user_id INT PRIMARY KEY,
    name    TEXT
);

CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title    TEXT
);

CREATE TABLE MovieRating (
    movie_id   INT,
    user_id    INT,
    rating     INT,
    created_at DATE,
    PRIMARY KEY (movie_id, user_id)
);

INSERT INTO Users_28 (user_id, name) VALUES
(1, 'Daniel'),
(2, 'Monica'),
(3, 'Maria'),
(4, 'James');

INSERT INTO Movies (movie_id, title) VALUES
(1, 'Avengers'),
(2, 'Frozen 2'),
(3, 'Joker');

INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES
(1, 1, 3, '2020-01-12'),
(2, 1, 4, '2020-02-11'),
(3, 1, 2, '2020-02-12'),
(1, 2, 5, '2020-02-17'),
(3, 2, 3, '2020-02-22'),
(1, 3, 4, '2020-02-21'),
(2, 3, 5, '2020-02-18'),
(3, 3, 4, '2020-03-01'),
(2, 4, 3, '2020-02-14');
```

---

#### Solution

```sql
select t.name from (
    select
    u.name,
    count(distinct movie_id)
    from MovieRating as mr
    join Users_28 as u
    on mr.user_id = u.user_id
    group by 1
    order by 2 desc, name asc
    limit 1
) as t
union
select t.title from (
    select
    m.title,
    avg(rating) as avg_rating
    from MovieRating as mr
    join Movies as m
    on mr.movie_id = m.movie_id
    where extract(year from created_at) = 2020
    and extract(month from created_at) = 2
    group by 1
    limit 1
) as t                     

```

---

#### Explanation

- This uses `UNION ALL` to combine two independent queries, each returning exactly one row.
- **First query:** Finds the user who rated the most movies. `COUNT(rating)` counts total ratings per user. Tiebreaker: `name ASC` (lexicographically smallest).
- **Second query:** Finds the movie with the highest average rating in Feb 2020. `strftime('%Y-%m', created_at) = '2020-02'` filters to February 2020. Tiebreaker: `title ASC`.
- Each subquery must be wrapped in parentheses to have its own `ORDER BY` and `LIMIT`.
- `UNION ALL` is slightly faster than `UNION` since we know the results are different types.

---

#### Sample Output

| results      |
|--------------|
| Daniel       |
| Frozen 2     |

---