-- ============================================================
-- 1. CREATE TABLES
-- ============================================================

CREATE TABLE users (
    user_id     INT PRIMARY KEY,
    signup_date DATE,
    country     TEXT,
    plan        TEXT          -- 'free' | 'premium'
);

CREATE TABLE orders (
    order_id   INT PRIMARY KEY,
    user_id    INT,
    order_date DATE,
    amount     DECIMAL(10,2),
    product_id INT
);

CREATE TABLE sessions (
    session_id   INT PRIMARY KEY,
    user_id      INT,
    session_date DATE,
    duration_sec INT,
    platform     TEXT          -- 'iOS' | 'android' | 'web'
);

CREATE TABLE friend_requests (
    id           INT PRIMARY KEY,
    sender_id    INT,
    receiver_id  INT,
    request_date DATE,
    status       TEXT          -- 'accepted' | 'rejected' | 'pending'
);

CREATE TABLE user_actions (
    id          INT PRIMARY KEY,
    user_id     INT,
    action_date DATE,
    action_type TEXT           -- 'login' | 'purchase' | 'click' | 'tweet'
);

-- ============================================================
-- 2. INSERT — users
--    Covers: premium/free split, multi-country pairs (self-join),
--            user_id 9 is premium with NO orders (premium users
--            with no orders question)
-- ============================================================

INSERT INTO users (user_id, signup_date, country, plan) VALUES
(1,  '2023-01-01', 'US', 'premium'),
(2,  '2023-01-15', 'US', 'free'),
(3,  '2023-02-01', 'UK', 'premium'),
(4,  '2023-02-10', 'UK', 'free'),
(5,  '2023-03-01', 'CA', 'premium'),
(6,  '2023-03-15', 'CA', 'free'),
(7,  '2023-04-01', 'US', 'premium'),
(8,  '2023-04-15', 'UK', 'free'),
(9,  '2023-05-01', 'CA', 'premium'),  -- premium, NO orders → answers "premium users with no orders"
(10, '2023-05-15', 'US', 'free');


-- ============================================================
-- 3. INSERT — orders
--    Covers:
--      • Month-over-month & YoY revenue growth
--      • Top product by revenue per month
--      • Cumulative / running revenue
--      • First & second order per user (FIRST_VALUE, window)
--      • Revenue share per product
--      • Users above average order amount
--      • Rank users by spend within country
--      • Conversion rate (signup → first order within 7 days)
--      • Spending tiers (CASE WHEN)
--      • Products only bought by premium users
--      • Users with spending INCREASING every month (user 5)
--      • Shopping sprees: 3+ consecutive order days (user 1: Jun 1-2-3)
--      • Reactivated users: 30+ day gap then new order (user 4)
--      • Duplicate / repeated payments (user 2: same amount same day)
--      • Multiple orders same day (user 10)
--      • 2nd purchase within 30 days of first (user 3)
--      • Longest streak of order days (user 7: 3 days)
--      • Rolling / moving averages
-- ============================================================

INSERT INTO orders (order_id, user_id, order_date, amount, product_id) VALUES
(1,  1, '2023-01-05', 150.00, 1),
(2,  1, '2023-06-01', 200.00, 2),
(3,  1, '2023-06-02', 220.00, 1),
(4,  1, '2023-06-03', 250.00, 3),
(5,  1, '2023-07-10', 180.00, 2),
(6,  1, '2023-08-05', 300.00, 1),
(7,  2, '2023-01-20',  50.00, 2),
(8,  2, '2023-01-20',  50.00, 2),
(9,  2, '2023-03-10',  75.00, 1),
(10, 2, '2023-04-15',  90.00, 3),
(11, 2, '2023-06-20', 110.00, 2),
(12, 3, '2023-06-01', 120.00, 1),
(13, 3, '2023-06-20', 130.00, 2),
(14, 3, '2023-08-01', 200.00, 3),
(15, 4, '2023-01-10',  60.00, 1),
(16, 4, '2023-03-20',  80.00, 2),
(17, 4, '2023-06-10',  90.00, 1),
(18, 5, '2023-01-15', 100.00, 3),
(19, 5, '2023-02-15', 200.00, 2),
(20, 5, '2023-03-15', 300.00, 1),
(21, 5, '2023-04-15', 400.00, 3),
(22, 6, '2023-02-10',  40.00, 2),
(23, 6, '2023-04-10',  60.00, 1),
(24, 6, '2023-06-10',  80.00, 3),
(25, 7, '2023-05-01', 500.00, 1),
(26, 7, '2023-06-01', 450.00, 2),
(27, 7, '2023-06-02', 480.00, 1),
(28, 7, '2023-06-03', 510.00, 3),
(29, 7, '2023-07-01', 600.00, 1),
(30, 8, '2023-03-05',  35.00, 2),
(31, 8, '2023-05-05',  45.00, 1),
(32, 8, '2023-07-05',  55.00, 3),
(33, 10, '2023-04-01', 110.00, 1),
(34, 10, '2023-04-01', 120.00, 2),
(35, 10, '2023-06-01', 130.00, 3),
(36, 10, '2023-07-15',  95.00, 1);

-- ============================================================
-- 4. INSERT — sessions
--    Covers:
--      • Active 3+ consecutive days (user 1: Jun 1-2-3-4)
--      • Median session duration per user
--      • Avg session duration by country & platform (needs JOIN with users)
--      • Users on both iOS AND android (users 1, 3, 7)
--      • Users on ALL 3 platforms: iOS, android, web (users 2, 10)
--      • Single-platform users (user 4: web only, user 5: iOS only)
--      • Day with highest distinct active users
--      • Rolling 3-order (session) averages
-- ============================================================

INSERT INTO sessions (session_id, user_id, session_date, duration_sec, platform) VALUES
(1,  1, '2023-06-01', 1200, 'iOS'),
(2,  1, '2023-06-02',  800, 'android'),
(3,  1, '2023-06-03', 1500, 'iOS'),
(4,  1, '2023-06-04',  900, 'iOS'),
(5,  1, '2023-07-01',  600, 'android'),
(6,  2, '2023-06-01',  500, 'iOS'),
(7,  2, '2023-06-02',  700, 'android'),
(8,  2, '2023-06-03',  400, 'web'),
(9,  2, '2023-07-10',  300, 'iOS'),
(10, 3, '2023-06-05',  900, 'iOS'),
(11, 3, '2023-06-06', 1100, 'android'),
(12, 3, '2023-07-05',  800, 'iOS'),
(13, 4, '2023-06-10',  600, 'web'),
(14, 4, '2023-06-15',  500, 'web'),
(15, 4, '2023-07-10',  550, 'web'),
(16, 5, '2023-06-01', 1000, 'iOS'),
(17, 5, '2023-06-08', 1200, 'iOS'),
(18, 5, '2023-07-01',  950, 'iOS'),
(19, 6, '2023-06-03',  450, 'android'),
(20, 6, '2023-06-10',  550, 'android'),
(21, 7, '2023-06-01', 2000, 'iOS'),
(22, 7, '2023-06-02', 1800, 'android'),
(23, 7, '2023-06-03', 2200, 'iOS'),
(24, 8, '2023-06-01',  300, 'web'),
(25, 8, '2023-06-05',  400, 'iOS'),
(26, 10, '2023-06-01',  700, 'iOS'),
(27, 10, '2023-06-02',  800, 'android'),
(28, 10, '2023-06-03',  600, 'web');


-- ============================================================
-- 5. INSERT — friend_requests
--    Covers:
--      • User with highest acceptance rate (min 2 sent) → user 5: 3/3
--      • Users with orders but NO friend requests sent
--      • Self-join mutual friends
--      • Users from same country pairs (via users JOIN)
-- ============================================================

INSERT INTO friend_requests (id, sender_id, receiver_id, request_date, status) VALUES
(1,  2, 1,  '2023-02-01', 'accepted'),
(2,  2, 3,  '2023-02-05', 'accepted'),
(3,  2, 4,  '2023-02-10', 'rejected'),
(4,  3, 1,  '2023-03-01', 'accepted'),
(5,  3, 5,  '2023-03-05', 'rejected'),
(6,  4, 2,  '2023-03-10', 'accepted'),
(7,  4, 6,  '2023-03-15', 'accepted'),
(8,  5, 1,  '2023-04-01', 'accepted'),
(9,  5, 2,  '2023-04-05', 'accepted'),
(10, 5, 3,  '2023-04-10', 'accepted'),
(11, 1, 6,  '2023-05-01', 'accepted'),
(12, 1, 7,  '2023-05-05', 'rejected'),
(13, 6, 1,  '2023-05-10', 'pending'),
(14, 7, 2,  '2023-06-01', 'accepted'),
(15, 7, 3,  '2023-06-05', 'rejected');

-- ============================================================
-- 6. INSERT — user_actions
--    Covers:
--      • Most common action type per user (MODE)
--      • Click-through rate: purchases / logins per user
--      • Histogram of tweets per user in a year
--      • Users active on ALL 3 platforms (via action tracking)
--      • Day with most active users
-- ============================================================

INSERT INTO user_actions (id, user_id, action_date, action_type) VALUES

(1,  1, '2023-06-01', 'login'),
(2,  1, '2023-06-01', 'purchase'),
(3,  1, '2023-06-02', 'login'),
(4,  1, '2023-06-02', 'click'),
(5,  1, '2023-06-03', 'login'),
(6,  2, '2023-06-01', 'login'),
(7,  2, '2023-06-02', 'login'),
(8,  2, '2023-06-02', 'tweet'),
(9,  2, '2023-06-03', 'tweet'),
(10, 2, '2023-06-04', 'tweet'),
(11, 3, '2023-06-01', 'purchase'),
(12, 3, '2023-06-02', 'purchase'),
(13, 3, '2023-06-03', 'click'),
(14, 4, '2023-06-01', 'login'),
(15, 4, '2023-06-02', 'login'),
(16, 4, '2023-06-03', 'login'),
(17, 4, '2023-06-04', 'login'),
(18, 5, '2023-06-01', 'login'),
(19, 5, '2023-06-01', 'purchase'),
(20, 5, '2023-06-02', 'login'),
(21, 5, '2023-06-02', 'purchase'),
(22, 6, '2023-06-01', 'tweet'),
(23, 6, '2023-06-02', 'tweet'),
(24, 6, '2023-06-03', 'click'),
(25, 7, '2023-06-01', 'login'),
(26, 7, '2023-06-02', 'purchase'),
(27, 7, '2023-06-03', 'login'),
(28, 8, '2023-06-01', 'click'),
(29, 8, '2023-06-02', 'click'),
(30, 10, '2023-06-01', 'login'),
(31, 10, '2023-06-01', 'purchase'),
(32, 10, '2023-06-02', 'login');

-- ============================================================
-- Reported Posts II — Avg daily % of spam posts removed
-- ============================================================

CREATE TABLE Actions (
    action_id   INT PRIMARY KEY,
    user_id     INT,
    post_id     INT,
    action_date DATE,
    action      TEXT,       -- 'report' | 'view' | 'like'
    extra       TEXT        -- 'spam' | NULL
);

CREATE TABLE Removals (
    post_id     INT PRIMARY KEY,
    remove_date DATE
);

INSERT INTO Actions (action_id, user_id, post_id, action_date, action, extra) VALUES
(1,  1, 100, '2019-07-01', 'report', 'spam'),
(2,  2, 101, '2019-07-01', 'report', 'spam'),
(3,  3, 102, '2019-07-01', 'view',   NULL),
(4,  1, 103, '2019-07-02', 'report', 'spam'),
(5,  2, 104, '2019-07-02', 'report', 'spam'),
(6,  3, 105, '2019-07-02', 'report', NULL),
(7,  1, 106, '2019-07-03', 'report', 'spam'),
(8,  2, 106, '2019-07-03', 'report', 'spam'),
(9,  1, 107, '2019-07-04', 'report', 'spam'),
(10, 2, 108, '2019-07-04', 'report', 'spam');

INSERT INTO Removals (post_id, remove_date) VALUES
(100, '2019-07-01'),
(101, '2019-07-02'),
(103, '2019-07-02'),
(106, '2019-07-03');
-- Expected daily %: 100, 50, 100, 0 → AVG = 62.50

-- ============================================================
-- Most Experienced Employee per Project
-- ============================================================

CREATE TABLE Employee (
    employee_id      INT PRIMARY KEY,
    name             TEXT,
    experience_years INT
);

CREATE TABLE Project (
    project_id  INT,
    employee_id INT,
    PRIMARY KEY (project_id, employee_id)
);

INSERT INTO Employee (employee_id, name, experience_years) VALUES
(1, 'Khaled',   3),
(2, 'Ali',      2),
(3, 'John',     3),    
(4, 'Doe',      2),
(5, 'Sarah',    5),   
(6, 'Mike',     1);   

INSERT INTO Project (project_id, employee_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 6),
(4, 4),
(4, 5);

-- ============================================================
-- Game Play Analysis III — Running total of games played
-- ============================================================

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

-- ============================================================
-- Movie Rating — Top reviewer + top-rated movie in Feb 2020
-- ============================================================

CREATE TABLE Users_28 (
    user_id INT PRIMARY KEY,
    name    TEXT
);

CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title    TEXT
);

CREATE TABLE MovieRating (
    movie_id   INT,
    user_id    INT,
    rating     INT,
    created_at DATE,
    PRIMARY KEY (movie_id, user_id)
);

INSERT INTO Users_28 (user_id, name) VALUES
(1, 'Daniel'),
(2, 'Monica'),
(3, 'Maria'),
(4, 'James');

INSERT INTO Movies (movie_id, title) VALUES
(1, 'Avengers'),
(2, 'Frozen 2'),
(3, 'Joker');

INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES
(1, 1, 3, '2020-01-12'),
(2, 1, 4, '2020-02-11'),
(3, 1, 2, '2020-02-12'),
(1, 2, 5, '2020-02-17'),
(3, 2, 3, '2020-02-22'),
(1, 3, 4, '2020-02-21'),
(2, 3, 5, '2020-02-18'),
(3, 3, 4, '2020-03-01'),
(2, 4, 3, '2020-02-14');

-- ============================================================
-- Unpopular Books — < 10 copies sold in last year
--      Reference date: 2019-06-23
-- ============================================================

CREATE TABLE Books (
    book_id        INT PRIMARY KEY,
    name           TEXT,
    available_from DATE
);

CREATE TABLE Orders_29 (
    order_id      INT PRIMARY KEY,
    book_id       INT,
    quantity      INT,
    dispatch_date DATE
);

INSERT INTO Books (book_id, name, available_from) VALUES
(1, 'Kalila And Demna',    '2010-01-01'),   
(2, 'The Pilot Masterbook', '2018-07-15'),  
(3, 'The Surveyor',        '2019-02-01'),   
(4, 'The Great Code',      '2019-06-01'),   
(5, 'Heart of SQL',        '2017-04-01'),   
(6, 'Brave New World',     '2015-01-01');   

INSERT INTO Orders_29 (order_id, book_id, quantity, dispatch_date) VALUES
(1, 2, 5,  '2018-10-01'),
(2, 2, 5,  '2019-04-15'),
(3, 3, 3,  '2019-03-01'),
(4, 3, 5,  '2019-05-10'),
(5, 4, 2,  '2019-06-15'),
(6, 5, 15, '2017-08-01'),
(7, 5, 5,  '2019-01-20'),
(8, 6, 7,  '2019-02-01'),
(9, 6, 3,  '2019-03-15');

-- ============================================================
-- Page Recommendations — Recommend pages via friends' likes
-- ============================================================

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

-- ============================================================
-- Most Recent Three Orders per customer
-- ============================================================

CREATE TABLE Customers_31 (
    customer_id INT PRIMARY KEY,
    name        TEXT
);

CREATE TABLE Orders_31 (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    order_date  DATE
);

INSERT INTO Customers_31 (customer_id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');

INSERT INTO Orders_31 (order_id, customer_id, order_date) VALUES
(1,  1, '2020-03-01'),
(2,  1, '2020-04-15'),
(3,  1, '2020-05-20'),
(4,  1, '2020-06-15'),
(5,  1, '2020-07-10'),
(6,  1, '2020-07-31'),
(7,  2, '2020-01-10'),
(8,  2, '2020-03-25'),
(9,  2, '2020-05-05'),
(10, 3, '2020-02-14'),
(11, 3, '2020-06-30'),
(12, 4, '2020-04-01'),
(13, 4, '2020-05-15'),
(14, 4, '2020-08-01'),
(15, 4, '2020-08-01');

-- ============================================================
-- Second Most Recent Activity
-- ============================================================

CREATE TABLE UserActivity (
    username  TEXT,
    activity  TEXT,
    startDate DATE,
    endDate   DATE
);

INSERT INTO UserActivity (username, activity, startDate, endDate) VALUES
('Alice', 'Travel',  '2020-02-12', '2020-02-20'),
('Alice', 'Dancing', '2020-02-21', '2020-02-23'),
('Alice', 'Travel',  '2020-02-24', '2020-02-28'),
('Bob',   'Painting', '2020-01-01', '2020-01-02'),
('Charlie', 'Singing',  '2020-03-01', '2020-03-05'),
('Charlie', 'Cooking',  '2020-03-06', '2020-03-10'),
('Diana', 'Reading', '2020-01-10', '2020-01-15'),
('Diana', 'Running', '2020-02-01', '2020-02-10'),
('Diana', 'Hiking',  '2020-03-01', '2020-03-08'),
('Diana', 'Yoga',    '2020-04-01', '2020-04-05');

-- ============================================================
-- QUICK REFERENCE: which scenario each user is designed for
-- ============================================================
/*
USER  | PLAN    | COUNTRY | KEY SCENARIOS
------|---------|---------|-----------------------------------------------
1     | premium | US      | Shopping spree (orders Jun 1-2-3)
                          | Active 3+ consecutive session days (Jun 1-2-3-4)
                          | iOS + android sessions
2     | free    | US      | Duplicate/repeated payment (Jan 20, $50 x2)
                          | All 3 session platforms (iOS, android, web)
                          | Most common action = tweet
3     | premium | UK      | 2nd purchase within 30 days of first
                          | iOS + android sessions
4     | free    | UK      | Reactivated user (gaps of 69 & 82 days)
                          | Single-platform sessions (web only)
5     | premium | CA      | Spending increases every month (100→200→300→400)
                          | Highest friend-request acceptance rate (3/3)
                          | Single-platform sessions (iOS only)
6     | free    | CA      | No friend requests sent (appears in that result)
                          | android-only sessions
7     | premium | US      | Longest order streak (Jun 1-2-3)
                          | High spender for ranking questions
8     | free    | UK      | Never sent friend requests
                          | web + iOS sessions
9     | premium | CA      | NO orders at all → "premium users with no orders"
10    | free    | US      | Multiple orders same day (Apr 1)
                          | All 3 session platforms
*/