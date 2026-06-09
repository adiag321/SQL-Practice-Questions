## Session Data Analysis

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Companies** | Amazon |
| **Link** | https://www.tryexponent.com/practice/prepare/session-data-analysis |

---

#### Problem Statement

You are given a dataset with one row per user session. The table contains `session_id`, `country`, and `session_time` (in seconds).

*Asked at Amazon and 2 other times.*

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS sessions;

CREATE TABLE sessions (
    session_id INT PRIMARY KEY,
    country VARCHAR(50),
    session_time INT  -- session length in seconds
);

-- US: 5 sessions
INSERT INTO sessions (session_id, country, session_time) VALUES
(1,  'US', 120),
(2,  'US', 250),
(3,  'US', 350),
(4,  'US', 620),
(5,  'US', 900);

-- UK: 5 sessions
INSERT INTO sessions (session_id, country, session_time) VALUES
(6,  'UK', 90),
(7,  'UK', 200),
(8,  'UK', 400),
(9,  'UK', 750),
(10, 'UK', 1100);

-- India: 3 sessions
INSERT INTO sessions (session_id, country, session_time) VALUES
(11, 'India', 150),
(12, 'India', 500),
(13, 'India', 800);

-- Germany: 3 sessions
INSERT INTO sessions (session_id, country, session_time) VALUES
(14, 'Germany', 60),
(15, 'Germany', 310),
(16, 'Germany', 650);

-- Brazil: 8 sessions
INSERT INTO sessions (session_id, country, session_time) VALUES
(17, 'Brazil', 100),
(18, 'Brazil', 180),
(19, 'Brazil', 220),
(20, 'Brazil', 350),
(21, 'Brazil', 450),
(22, 'Brazil', 700),
(23, 'Brazil', 950),
(24, 'Brazil', 1300);
```

---

#### Part 1: Calculate Average Session Time

Calculate the average session time for sessions that are longer than 3 minutes (180 seconds).

#### Solution

```sql
SELECT
    AVG(session_time) AS avg_session_time
FROM sessions
WHERE session_time > 180;
```

#### Sample Output

| avg_session_time |
|------------------|
| 639.29           |

---

#### Part 2: Visualize Data (Histogram)

Create a histogram of session lengths using bins of 5 minutes (300 seconds). Output: 1 column for the bin (in minutes), 1 column for the count of sessions in that bin.

#### Solution

```sql
SELECT
    FLOOR(session_time / 300) AS session_minutes,
    COUNT(*) AS session_count
FROM sessions
GROUP BY 1
ORDER BY 1;
```

#### Sample Output

| session_minutes | session_count |
|-----------------|---------------|
| 0               | 6             |
| 1               | 7             |
| 2               | 4             |
| 3               | 4             |
| 4               | 3             |

---

#### Part 3: Find Similar Countries

"Similar countries" are countries that have a number of sessions within 10% of each other. Identify such pairs of countries. Output: `country_a`, `country_b`.

#### Solution

```sql
WITH country_counts AS (
    SELECT
        country,
        COUNT(*) AS session_count
    FROM sessions
    GROUP BY 1
),
country_pairs AS (
    SELECT
        c1.country AS country_a,
        c2.country AS country_b,
        ABS(c1.session_count - c2.session_count) * 1.00 / c1.session_count AS diff_pct
    FROM country_counts c1
    JOIN country_counts c2 ON c1.country <> c2.country
    WHERE ABS(c1.session_count - c2.session_count) * 1.00 / c1.session_count <= 0.1
)
SELECT
    country_a,
    country_b
FROM country_pairs;
```

#### Sample Output

| country_a | country_b |
|-----------|-----------|
| US        | UK        |
| UK        | US        |
| India     | Germany   |
| Germany   | India     |
