## Video Game Matchmaking

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Companies** | Electronic Arts |

---

#### Problem Statement

Electronic Arts makes popular online games that feature multiplayer "matchmaking". For a special event, EA wants every player to play against every other player exactly once. Additionally, every player has a "level" that indicates their skill and experience in the game.

You're given a table `players` with the following columns:

- `player_name` (string) – This column contains the username of the player.
- `level` (integer) – This represents the skill level of the player, with higher numbers indicating greater skill.

Write a SQL query that generates all possible match-ups between the players in the `players` table and also calculates the disparity in level between the two players in each matchup. To keep the games evenly matched, we'd like to prevent matches where the players are more than 5 levels apart. Return the list of matches in ascending order of `level_disparity`.

Your output should contain the following columns: `player1`, `player2` (both populated with player names), `level_disparity`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS players;

CREATE TABLE players (
    player_name VARCHAR(50),
    level INTEGER
);

INSERT INTO players (player_name, level) VALUES
('Alice', 10),
('Bob', 12),
('Charlie', 20),
('Dave', 8),
('Eve', 15);
```

---

#### Solution

```sql
-- postgresql
SELECT
    p1.player_name AS player1,
    p2.player_name AS player2,
    ABS(p1.level - p2.level) AS level_disparity
FROM players AS p1
JOIN players AS p2
    ON p1.player_name < p2.player_name
WHERE ABS(p1.level - p2.level) <= 5
ORDER BY level_disparity;
```

---

#### Sample Output

| player1 | player2 | level_disparity |
|---------|---------|------------------|
| Alice   | Bob     | 2                |
| Alice   | Dave    | 2                |
| Bob     | Eve     | 3                |
| Bob     | Dave    | 4                |
| Alice   | Eve     | 5                |
| Charlie | Eve     | 5                |
