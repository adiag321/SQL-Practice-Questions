## Game Play Analysis III: Cumulative games played per player.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Self-Join · Window Functions · Running Total |
| **Companies** | LeetCode |

---

#### Problem Statement

Report the running total of games played for each player, ordered by date. For each row, show the cumulative sum of `games_played` up to and including that date.

---

#### Create and Insert Statements

```sql
CREATE TABLE Activity (
    player_id    INT,
    device_id    INT,
    event_date   DATE,
    games_played INT,
    PRIMARY KEY (player_id, event_date)
);

INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-05-02', 6),
(1, 3, '2017-06-25', 1),
(2, 3, '2017-01-01', 4),
(3, 1, '2016-03-02', 0),   
(3, 4, '2018-07-03', 1),
(3, 4, '2018-07-04', 5),
(3, 1, '2019-01-01', 9);
```

---

#### Solution

```sql
-- Approach 1: Self-join (running total)
SELECT 
    a1.player_id, 
    a1.event_date,
    a1.games_played,
    SUM(a2.games_played) AS games_played_so_far
FROM Activity a1
INNER JOIN Activity a2
    ON a1.player_id = a2.player_id
    AND a2.event_date <= a1.event_date
GROUP BY a1.player_id, a1.event_date
```

```sql
-- Approach 2: Window function (preferred)
SELECT 
    player_id, 
    event_date,
    games_played,
    SUM(games_played) OVER (PARTITION BY player_id ORDER BY event_date ROWS UNBOUNDED PRECEDING) AS games_played_so_far
FROM Activity
```

---

#### Explanation

- **Self-join approach:** For each row in `a1`, join ALL rows from `a2` with the same player and an earlier-or-equal date, then `SUM`. This creates a running total. Complexity: O(n²) per player.
- **Window function approach:** Uses `SUM() OVER()` with `ROWS UNBOUNDED PRECEDING` to compute a cumulative sum within each player partition. This is more readable and typically faster — O(n) per player.
- The window function approach is preferred in modern SQL engines.

---

#### Sample Output

| player_id | event_date | games_played_so_far |
|-----------|------------|---------------------|
| 1         | 2016-03-01 | 5                   |
| 1         | 2016-05-02 | 11                  |
| 1         | 2017-06-25 | 12                  |

---