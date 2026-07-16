## Question 1: First Login Date

### Problem Statement
The table `Activity` shows the activity of players of some games. Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device. Find the first login date for each player. Return the result table in any order.

### Create and Insert Statements

```sql
CREATE TABLE Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT,
    PRIMARY KEY (player_id, event_date)
);

INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-05-02', 6),
(2, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);
```

### Expected Output
| player_id | device_id | event_date | games_played |
| --------- | --------- | ---------- | ------------ |
| 1         | 2         | 2016-03-01 | 5            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |

### Solution

```sql
with cte as (select
*,
row_number() over(partition by player_id order by event_date) as rnk 
from Activity
)

select
player_id,
device_id,
event_date,
games_played
from cte 
where rnk = 1;
```
