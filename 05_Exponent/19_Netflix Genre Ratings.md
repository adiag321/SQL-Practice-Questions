## Netflix Genre Ratings

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/practice/prepare/netflix-genre-ratings |

---

#### Problem Statement

Netflix is a popular streaming platform that offers a wide variety of movies spanning multiple genres. Users can rate movies they've watched, providing valuable feedback on the content. With the diverse selection, understanding the average rating for each genre can help in content recommendation and analysis.

You are given the following database tables:

**`movie` table:**
*   `movie_id` (integer)
*   `title` (string)
*   `genre` (string)

**`rating` table:**
*   `user_id` (integer)
*   `movie_id` (integer)
*   `rating` (integer)

Write a SQL query that returns a table listing each movie, its average rating, and the average rating of its genre. The table should have columns for the movie title `title`, the average movie rating `avg_rating`, and the average genre rating `genre_rating`. Order the result by the movie title. Round ratings to 1 decimal place.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS movie;

CREATE TABLE movie (
    movie_id INTEGER PRIMARY KEY,
    title VARCHAR(255),
    genre VARCHAR(100)
);

CREATE TABLE rating (
    user_id INTEGER,
    movie_id INTEGER,
    rating INTEGER,
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
);

INSERT INTO movie (movie_id, title, genre) VALUES
(1, 'The Shawshank Redemption', 'Drama'),
(2, 'The Godfather', 'Drama'),
(3, 'The Dark Knight', 'Action'),
(4, 'Pulp Fiction', 'Action'),
(5, 'Inception', 'Action');

INSERT INTO rating (user_id, movie_id, rating) VALUES
(101, 1, 5),
(102, 1, 4),
(103, 2, 5),
(104, 2, 4),
(105, 3, 5),
(106, 3, 4),
(107, 4, 3),
(108, 5, 4);
```

---

#### Solution

```sql
WITH cte1 AS (
    SELECT
        m.title,
        m.genre,
        r.rating
    FROM movie AS m
    JOIN rating AS r ON m.movie_id = r.movie_id
),
cte2 AS (
    SELECT
        title,
        ROUND(AVG(rating), 1) AS avg_rating
    FROM cte1
    GROUP BY 1
),
cte3 AS (
    SELECT
        genre,
        ROUND(AVG(rating), 1) AS genre_rating
    FROM cte1
    GROUP BY 1
)
SELECT DISTINCT
    c1.title,
    c2.avg_rating,
    c3.genre_rating
FROM cte1 AS c1
JOIN cte2 AS c2 ON c1.title = c2.title
JOIN cte3 AS c3 ON c1.genre = c3.genre
ORDER BY 1;
```

---

#### Sample Output

| title | avg_rating | genre_rating |
|-------|------------|--------------|
| Inception | 4.0 | 4.0 |
| Pulp Fiction | 3.0 | 4.0 |
| The Dark Knight | 4.5 | 4.0 |
| The Godfather | 4.5 | 4.5 |
| The Shawshank Redemption | 4.5 | 4.5 |