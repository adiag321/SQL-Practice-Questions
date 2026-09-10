## Nth Ranked Player

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |

---

#### Problem Statement

Given players (player_id, player_name, score), return the names, scores, and ranking of the 4th, 6th, and 11th ranked players by score.

---

#### Create & Insert Statements

The following data is illustrative and is included to make the query executable.

```sql
CREATE TABLE players (player_id INTEGER PRIMARY KEY, player_name TEXT, score INTEGER);
INSERT INTO players VALUES
(1, 'Ava', 110), (2, 'Ben', 100), (3, 'Cy', 90), (4, 'Di', 80),
(5, 'Eli', 70), (6, 'Fox', 60), (7, 'Gia', 50), (8, 'Hal', 40),
(9, 'Ian', 30), (10, 'Joy', 20), (11, 'Kai', 10);
```

---

#### Solution

Assumption: ranking uses competition ranking (`RANK`), so ties can create skipped ranking numbers.

```sql
-- postgresql

WITH ranked_players AS (
    SELECT player_name, score,
           RANK() OVER (ORDER BY score DESC) AS ranking
    FROM players
)
SELECT player_name, score, ranking
FROM ranked_players
WHERE ranking IN (4, 6, 11)
ORDER BY ranking;
```

---

#### Sample Output

| player_name | score | ranking |
|--------------|-------|---------|
| Di | 80 | 4 |
| Fox | 60 | 6 |
| Kai | 10 | 11 |

> Assumption: ranking uses competition ranking (`RANK`), so ties can create skipped ranking numbers.
