## Top 5 Artists

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Ranking |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/top-5-artists |

---

#### Problem Statement

Find the top 5 artists with the highest number of songs that appeared in the global top‑10 ranking. Return `artist_name` and the count of their top‑10 songs, ordered by the count descending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS songs;
DROP TABLE IF EXISTS global_song_rank;

CREATE TABLE artists (
    artist_id   INTEGER PRIMARY KEY,
    artist_name VARCHAR(100)
);

CREATE TABLE songs (
    song_id   INTEGER PRIMARY KEY,
    artist_id INTEGER,
    title     VARCHAR(200)
);

CREATE TABLE global_song_rank (
    song_id INTEGER,
    rank    INTEGER
);

INSERT INTO artists (artist_id, artist_name) VALUES
(1, 'Artist A'),
(2, 'Artist B'),
(3, 'Artist C'),
(4, 'Artist D');

INSERT INTO songs (song_id, artist_id, title) VALUES
(101, 1, 'Song A1'),
(102, 1, 'Song A2'),
(103, 2, 'Song B1'),
(104, 2, 'Song B2'),
(105, 2, 'Song B3'),
(106, 3, 'Song C1'),
(107, 4, 'Song D1');

INSERT INTO global_song_rank (song_id, rank) VALUES
(101, 5), (102, 12), (103, 3), (104, 8), (105, 9), (106, 15), (107, 2);
```

---

#### Solution

```sql
WITH cte AS (
    SELECT a.artist_name,
           COUNT(gsr.song_id) AS count_songs
    FROM global_song_rank gsr
    JOIN songs s   ON gsr.song_id = s.song_id
    JOIN artists a ON s.artist_id = a.artist_id
    WHERE gsr.rank <= 10
    GROUP BY a.artist_name
)
SELECT artist_name,
       count_songs
FROM (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY count_songs DESC) AS artist_rank
    FROM cte
) ranked
WHERE artist_rank <= 5
ORDER BY count_songs DESC;
```

---

#### Sample Output

| artist_name | count_songs |
|------------|-------------|
| Artist B   | 3 |
| Artist A   | 1 |
| Artist D   | 1 |
