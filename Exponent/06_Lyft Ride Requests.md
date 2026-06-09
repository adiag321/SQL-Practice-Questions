## Lyft Ride Requests

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Companies** | Lyft |
| **Link** | https://www.tryexponent.com/practice/prepare/lyft-ride-requests |

---

#### Problem Statement

Lyft is a popular ride-sharing platform that connects drivers with riders. Users place a car booking request when they need a ride, and while many of these requests get matched with drivers, some don't get any match.

Write a SQL query to find the average number of unmatched bookings per user. Your output should contain the following columns: `user_id`, `user_name`, `email`, `avg_unmatched_bookings` (rounded to the nearest 2 decimal places).

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    user_id INT,
    driver_id INT,
    booking_time TIMESTAMP,
    status VARCHAR(20)
);

INSERT INTO users (user_id, user_name, email) VALUES
(1, 'Alice', 'alice@email.com'),
(2, 'Bob', 'bob@email.com'),
(3, 'Charlie', 'charlie@email.com'),
(4, 'Diana', 'diana@email.com');

-- Alice: 2 Matched, 1 Unmatched -> avg_unmatched = 1/3 = 0.33
INSERT INTO bookings (booking_id, user_id, driver_id, booking_time, status) VALUES
(1, 1, 101, '2024-03-01 08:00:00', 'Matched'),
(2, 1, 102, '2024-03-02 09:30:00', 'Matched'),
(3, 1, NULL, '2024-03-03 10:00:00', 'Unmatched');

-- Bob: 1 Matched, 2 Unmatched -> avg_unmatched = 2/3 = 0.67
INSERT INTO bookings (booking_id, user_id, driver_id, booking_time, status) VALUES
(4, 2, 103, '2024-03-01 07:00:00', 'Matched'),
(5, 2, NULL, '2024-03-02 08:00:00', 'Unmatched'),
(6, 2, NULL, '2024-03-04 12:00:00', 'Unmatched');

-- Charlie: 3 Matched, 0 Unmatched -> avg_unmatched = 0/3 = 0.00
INSERT INTO bookings (booking_id, user_id, driver_id, booking_time, status) VALUES
(7, 3, 104, '2024-03-01 06:00:00', 'Matched'),
(8, 3, 105, '2024-03-02 07:30:00', 'Matched'),
(9, 3, 106, '2024-03-03 09:00:00', 'Matched');

-- Diana: 0 Matched, 2 Unmatched -> avg_unmatched = 2/2 = 1.00
INSERT INTO bookings (booking_id, user_id, driver_id, booking_time, status) VALUES
(10, 4, NULL, '2024-03-05 11:00:00', 'Unmatched'),
(11, 4, NULL, '2024-03-06 14:00:00', 'Unmatched');
```

---

#### Solution

```sql
SELECT
    u.user_id,
    u.user_name,
    u.email,
    ROUND(SUM(CASE WHEN status = 'Unmatched' THEN 1 ELSE 0 END) * 1.00 / COUNT(u.user_id), 2) AS avg_unmatched_bookings
FROM bookings AS b
JOIN users AS u ON b.user_id = u.user_id
GROUP BY 1, 2, 3;
```

---

#### Sample Output

| user_id | user_name | email             | avg_unmatched_bookings |
|---------|-----------|-------------------|------------------------|
| 1       | Alice     | alice@email.com   | 0.33                   |
| 2       | Bob       | bob@email.com     | 0.67                   |
| 3       | Charlie   | charlie@email.com | 0.00                   |
| 4       | Diana     | diana@email.com   | 1.00                   |