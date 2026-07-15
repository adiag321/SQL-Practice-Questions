## Page Recommendations: Recommend pages based on friends' likes.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | UNION · NOT IN · Self-Join |
| **Companies** | Meta (Facebook) |

---

#### Problem Statement

Recommend pages to `user_id = 1` that their friends like but they haven't liked yet. The `Friendship` table stores friendships in one direction only (either `(user1, user2)` or `(user2, user1)`), so both directions must be checked.

---

#### Create Tables and Insert Data

```sql
CREATE TABLE Friendship (
    user1_id INT,
    user2_id INT,
    PRIMARY KEY (user1_id, user2_id)
);

CREATE TABLE Likes (
    user_id INT,
    page_id INT,
    PRIMARY KEY (user_id, page_id)
);

INSERT INTO Friendship (user1_id, user2_id) VALUES
(1, 2),
(3, 1),
(1, 4),
(2, 3),
(2, 5);

INSERT INTO Likes (user_id, page_id) VALUES
(1, 10),
(1, 20),
(2, 20),   
(2, 40),   
(3, 30),   
(3, 50),   
(4, 10),   
(5, 60);   
```

---

#### Solution

```sql
-- Approach 1: Double LEFT JOIN
SELECT DISTINCT l.page_id AS recommended_page
FROM Likes l
LEFT JOIN Friendship f1 ON f1.user2_id = l.user_id
LEFT JOIN Friendship f2 ON f2.user1_id = l.user_id
WHERE (f1.user1_id = 1 OR f2.user2_id = 1)
    AND l.page_id NOT IN (
        SELECT page_id FROM Likes WHERE user_id = 1)
```

```sql
-- Approach 2: UNION for bidirectional friends (cleaner)
SELECT DISTINCT page_id AS recommended_page
FROM Likes
WHERE user_id IN (
    SELECT user2_id FROM Friendship WHERE user1_id = 1
    UNION
    SELECT user1_id FROM Friendship WHERE user2_id = 1
)
AND page_id NOT IN (
    SELECT page_id FROM Likes WHERE user_id = 1)
```

---

#### Explanation

- **Bidirectional friendship:** Since `Friendship` only stores pairs in one direction, we must check both `user1_id = 1` and `user2_id = 1` to find all friends.
- **Approach 1:** Joins `Likes` to `Friendship` from both directions. The `WHERE` clause picks rows where user 1 is on either side.
- **Approach 2 (preferred):** Uses `UNION` to combine both directions into a single list of friend IDs, then looks up their liked pages. More readable and handles the symmetry cleanly.
- `NOT IN` excludes pages user 1 already likes.
- `DISTINCT` ensures each page is recommended only once.

---

#### Sample Output

| recommended_page |
|------------------|
| 23               |
| 24               |
| 56               |

---