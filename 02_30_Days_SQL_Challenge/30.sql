-- 30/30 Days SQL Challenge
/*
Spotify Data Analyst Interview Questions
Question:
Write a SQL query to find the top 5 most popular songs by total number of listens. 
You have two tables: Songs (containing song_id, song_name, and artist_name) and 
Listens (containing listen_id, user_id, song_id, and listen_date).
*/
CREATE TABLE Songs (
    song_id INT PRIMARY KEY,
    song_name VARCHAR(255),
    artist_name VARCHAR(255)
);
CREATE TABLE Listens (
    listen_id INT PRIMARY KEY,
    user_id INT,
    song_id INT,
    listen_date DATE,
    FOREIGN KEY (song_id) REFERENCES Songs(song_id)
);

INSERT INTO Songs (song_id, song_name, artist_name) VALUES
(7, 'Song G', 'Artist X'),
(12, 'Song L', 'Artist Y'),
(3, 'Song C', 'Artist Z'),
(15, 'Song O', 'Artist W'),
(1, 'Song A', 'Artist X'),
(9, 'Song I', 'Artist Z'),
(5, 'Song E', 'Artist Y'),
(11, 'Song K', 'Artist X'),
(2, 'Song B', 'Artist Y'),
(14, 'Song N', 'Artist W'),
(8, 'Song H', 'Artist Y'),
(4, 'Song D', 'Artist X'),
(13, 'Song M', 'Artist Z'),
(6, 'Song F', 'Artist Z'),
(10, 'Song J', 'Artist X');

INSERT INTO Listens (listen_id, user_id, song_id, listen_date) VALUES
(12, 112, 8, '2024-03-22'),
(27, 127, 1, '2024-03-23'),
(5, 105, 2, '2024-03-22'),
(38, 138, 7, '2024-03-24'),
(1, 101, 1, '2024-03-22'),
(19, 119, 10, '2024-03-22'),
(33, 133, 3, '2024-03-24'),
(8, 108, 5, '2024-03-22'),
(42, 142, 8, '2024-03-25'),
(15, 115, 9, '2024-03-22'),
(3, 103, 2, '2024-03-22'),
(30, 130, 1, '2024-03-23'),
(21, 121, 11, '2024-03-23'),
(44, 144, 10, '2024-03-25'),
(9, 109, 6, '2024-03-22'),
(35, 135, 5, '2024-03-24'),
(17, 117, 10, '2024-03-22'),
(25, 125, 13, '2024-03-23'),
(6, 106, 3, '2024-03-22'),
(40, 140, 8, '2024-03-24'),
(14, 114, 8, '2024-03-22'),
(28, 128, 2, '2024-03-23'),
(2, 102, 1, '2024-03-22'),
(36, 136, 6, '2024-03-24'),
(11, 111, 7, '2024-03-22'),
(45, 145, 12, '2024-03-25'),
(23, 123, 12, '2024-03-23'),
(32, 132, 2, '2024-03-24'),
(7, 107, 4, '2024-03-22'),
(41, 141, 8, '2024-03-25'),
(18, 118, 10, '2024-03-22'),
(29, 129, 1, '2024-03-23'),
(4, 104, 2, '2024-03-22'),
(37, 137, 7, '2024-03-24'),
(13, 113, 8, '2024-03-22'),
(24, 124, 12, '2024-03-23'),
(31, 131, 1, '2024-03-23'),
(10, 110, 7, '2024-03-22'),
(39, 139, 7, '2024-03-24'),
(16, 116, 9, '2024-03-22'),
(26, 126, 14, '2024-03-23'),
(34, 134, 4, '2024-03-24'),
(20, 120, 10, '2024-03-22'),
(43, 143, 9, '2024-03-25'),
(22, 122, 11, '2024-03-23');


-- ---------------------------
-- My Solution
-- ---------------------------
SELECT
    song_name,
    times_of_listens,
    DENSE_RANK() OVER (ORDER BY times_of_listens DESC) AS rank
FROM
    (SELECT
        s.song_name,
        COUNT(l.listen_id) AS times_of_listens
    FROM
        Songs s
    JOIN
        Listens l ON s.song_id = l.song_id
    GROUP BY
        s.song_name) AS sub
ORDER BY
    times_of_listens DESC
LIMIT 5;

