# Challenging SQL Questions Asked at Twitch!

### <a href = 'https://www.stratascratch.com/blog/twitch-data-science-interview-question/'>Question 1 - Streamer Sessions by Initial Viewers</a>

Return the number of streamer sessions for each user whose very first session was as a viewer.
Include the user ID and count of streamer sessions for users whose earliest session (by session_start) was a 'viewer' session, regardless of whether they ever had a streamer session later. Sort the results by streamer session count in descending order, then by user ID in ascending order.

**Input Table:**
```
| user_id | session_start        | session_end          | session_id | session_type |
|---------|-----------------------|-----------------------|------------|--------------|
| 0       | 2020-08-11 05:51:31   | 2020-08-11 05:54:45   | 539        | streamer     |
| 2       | 2020-07-11 03:36:54   | 2020-07-11 03:37:08   | 840        | streamer     |
| 3       | 2020-11-26 11:41:47   | 2020-11-26 11:52:01   | 848        | streamer     |
| 1       | 2020-11-19 06:24:24   | 2020-11-19 07:24:38   | 515        | viewer       |
| 2       | 2020-11-14 03:36:05   | 2020-11-14 03:39:19   | 646        | viewer       |

```

**Create and Insert Statement:**
```sql
CREATE TABLE user_sessions (
    user_id VARCHAR(10),
    session_start DATETIME,
    session_end DATETIME,
    session_id INT,
    session_type VARCHAR(20)
);

INSERT INTO user_sessions (user_id, session_start, session_end, session_id, session_type) VALUES
('0', '2020-08-11 05:51:31', '2020-08-11 05:54:45', 539, 'streamer'),
('2', '2020-07-11 03:36:54', '2020-07-11 03:37:08', 840, 'streamer'),
('3', '2020-11-26 11:41:47', '2020-11-26 11:52:01', 848, 'streamer'),
('1', '2020-11-19 06:24:24', '2020-11-19 07:24:38', 515, 'viewer'),
('2', '2020-11-14 03:36:05', '2020-11-14 03:39:19', 646, 'viewer');
```

**Solution:**
```sql
with session_rnk as (
select
user_id,
session_type,
rank() over(partition by user_id order by session_start) as rnk
from twitch_sessions
),

viewer_session as (select
user_id
from session_rnk
where rnk = 1
and session_type = 'viewer'
),

select
user_id,
count(*) as total_sessions
from twitch_sessions
where user_id in (select user_id from viewer_session)
and session_type = 'streamer'
group by 1
order by 1;
```