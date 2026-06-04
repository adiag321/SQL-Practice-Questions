## Cities With Completed Trades

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | JOIN · Aggregation · GROUP BY |
| **Companies** | Robinhood |
| **Link** | https://datalemur.com/questions/completed-trades |

---

#### Problem Statement

Given tables of trades and users, write a query to retrieve the **top 3 cities** with the most completed trade orders, ordered by the number of completed orders in descending order.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS trades;
DROP TABLE IF EXISTS users;

CREATE TABLE trades (
    order_id   INTEGER,
    user_id    INTEGER,
    quantity   INTEGER,
    status     VARCHAR(20),
    date       DATE,
    price      DECIMAL(8, 2)
);

CREATE TABLE users (
    user_id    INTEGER,
    city       VARCHAR(50),
    email      VARCHAR(100),
    signup_date DATE
);

INSERT INTO users (user_id, city, email, signup_date) VALUES
(1, 'San Francisco', 'alice@email.com', '2021-01-01'),
(2, 'San Francisco', 'bob@email.com',   '2021-02-01'),
(3, 'New York',      'carol@email.com', '2021-03-01'),
(4, 'Chicago',       'dave@email.com',  '2021-04-01'),
(5, 'New York',      'eve@email.com',   '2021-05-01');

INSERT INTO trades (order_id, user_id, quantity, status, date, price) VALUES
(1, 1, 10, 'Completed', '2022-01-08', 9.80),
(2, 1, 20, 'Completed', '2022-02-08', 3.74),
(3, 2, 15, 'Completed', '2022-03-08', 5.00),
(4, 2,  5, 'Cancelled', '2022-04-08', 1.20),   -- excluded (Cancelled)
(5, 3, 30, 'Completed', '2022-05-08', 7.50),
(6, 4,  8, 'Completed', '2022-06-08', 2.30),
(7, 5, 12, 'Completed', '2022-07-08', 4.10);
-- San Francisco: 3, New York: 2, Chicago: 1
```

---

#### Solution

```sql
SELECT u.city, COUNT(t.user_id) AS total_orders
FROM trades t
INNER JOIN users u ON t.user_id = u.user_id
WHERE t.status = 'Completed'
GROUP BY u.city
ORDER BY total_orders DESC
LIMIT 3;
```

---

#### Sample Output

| city          | total_orders |
|---------------|--------------|
| San Francisco | 3            |
| New York      | 2            |
| Chicago       | 1            |
