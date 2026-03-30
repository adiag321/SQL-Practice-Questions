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

-- user 1 | US | premium  →  shopping spree Jun 1-2-3 ✓
(1,  1, '2023-01-05', 150.00, 1),
(2,  1, '2023-06-01', 200.00, 2),
(3,  1, '2023-06-02', 220.00, 1),
(4,  1, '2023-06-03', 250.00, 3),
(5,  1, '2023-07-10', 180.00, 2),
(6,  1, '2023-08-05', 300.00, 1),

-- user 2 | US | free  →  duplicate/repeated payment on Jan 20 ✓
(7,  2, '2023-01-20',  50.00, 2),
(8,  2, '2023-01-20',  50.00, 2),   -- same user, same amount, same day
(9,  2, '2023-03-10',  75.00, 1),
(10, 2, '2023-04-15',  90.00, 3),
(11, 2, '2023-06-20', 110.00, 2),

-- user 3 | UK | premium  →  2nd purchase within 30 days of 1st ✓
(12, 3, '2023-06-01', 120.00, 1),
(13, 3, '2023-06-20', 130.00, 2),   -- 19 days after first order
(14, 3, '2023-08-01', 200.00, 3),

-- user 4 | UK | free  →  reactivated user (gaps > 30 days) ✓
(15, 4, '2023-01-10',  60.00, 1),
(16, 4, '2023-03-20',  80.00, 2),   -- 69-day gap → reactivated
(17, 4, '2023-06-10',  90.00, 1),   -- 82-day gap → reactivated again

-- user 5 | CA | premium  →  spending increases every month ✓
(18, 5, '2023-01-15', 100.00, 3),
(19, 5, '2023-02-15', 200.00, 2),
(20, 5, '2023-03-15', 300.00, 1),
(21, 5, '2023-04-15', 400.00, 3),

-- user 6 | CA | free
(22, 6, '2023-02-10',  40.00, 2),
(23, 6, '2023-04-10',  60.00, 1),
(24, 6, '2023-06-10',  80.00, 3),

-- user 7 | US | premium  →  longest streak Jun 1-2-3 ✓ + high spender
(25, 7, '2023-05-01', 500.00, 1),
(26, 7, '2023-06-01', 450.00, 2),
(27, 7, '2023-06-02', 480.00, 1),
(28, 7, '2023-06-03', 510.00, 3),
(29, 7, '2023-07-01', 600.00, 1),

-- user 8 | UK | free
(30, 8, '2023-03-05',  35.00, 2),
(31, 8, '2023-05-05',  45.00, 1),
(32, 8, '2023-07-05',  55.00, 3),

-- user 9 | CA | premium  →  intentionally NO orders ✓

-- user 10 | US | free  →  multiple orders on same day ✓
(33, 10, '2023-04-01', 110.00, 1),
(34, 10, '2023-04-01', 120.00, 2),  -- same day as order 33
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

-- user 1 | US  →  4 consecutive days, iOS + android ✓
(1,  1, '2023-06-01', 1200, 'iOS'),
(2,  1, '2023-06-02',  800, 'android'),
(3,  1, '2023-06-03', 1500, 'iOS'),
(4,  1, '2023-06-04',  900, 'iOS'),
(5,  1, '2023-07-01',  600, 'android'),

-- user 2 | US  →  all 3 platforms ✓
(6,  2, '2023-06-01',  500, 'iOS'),
(7,  2, '2023-06-02',  700, 'android'),
(8,  2, '2023-06-03',  400, 'web'),
(9,  2, '2023-07-10',  300, 'iOS'),

-- user 3 | UK  →  iOS + android ✓
(10, 3, '2023-06-05',  900, 'iOS'),
(11, 3, '2023-06-06', 1100, 'android'),
(12, 3, '2023-07-05',  800, 'iOS'),

-- user 4 | UK  →  web only (single-platform user) ✓
(13, 4, '2023-06-10',  600, 'web'),
(14, 4, '2023-06-15',  500, 'web'),
(15, 4, '2023-07-10',  550, 'web'),

-- user 5 | CA  →  iOS only (single-platform user) ✓
(16, 5, '2023-06-01', 1000, 'iOS'),
(17, 5, '2023-06-08', 1200, 'iOS'),
(18, 5, '2023-07-01',  950, 'iOS'),

-- user 6 | CA  →  android only
(19, 6, '2023-06-03',  450, 'android'),
(20, 6, '2023-06-10',  550, 'android'),

-- user 7 | US  →  iOS + android, 3 consecutive days ✓
(21, 7, '2023-06-01', 2000, 'iOS'),
(22, 7, '2023-06-02', 1800, 'android'),
(23, 7, '2023-06-03', 2200, 'iOS'),

-- user 8 | UK  →  web + iOS
(24, 8, '2023-06-01',  300, 'web'),
(25, 8, '2023-06-05',  400, 'iOS'),

-- user 10 | US  →  all 3 platforms ✓
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
(8,  5, 1,  '2023-04-01', 'accepted'),  -- user 5 sends 3, all accepted ✓
(9,  5, 2,  '2023-04-05', 'accepted'),
(10, 5, 3,  '2023-04-10', 'accepted'),
(11, 1, 6,  '2023-05-01', 'accepted'),
(12, 1, 7,  '2023-05-05', 'rejected'),
(13, 6, 1,  '2023-05-10', 'pending'),
(14, 7, 2,  '2023-06-01', 'accepted'),
(15, 7, 3,  '2023-06-05', 'rejected');
-- Note: user 8 and user 10 never sent any requests
--       → they appear in "users with orders but no friend requests sent"


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

-- user 1  →  most common = 'login' (3 logins vs 1 purchase vs 1 click)
(1,  1, '2023-06-01', 'login'),
(2,  1, '2023-06-01', 'purchase'),
(3,  1, '2023-06-02', 'login'),
(4,  1, '2023-06-02', 'click'),
(5,  1, '2023-06-03', 'login'),

-- user 2  →  most common = 'tweet' (3 tweets vs 2 logins)
(6,  2, '2023-06-01', 'login'),
(7,  2, '2023-06-02', 'login'),
(8,  2, '2023-06-02', 'tweet'),
(9,  2, '2023-06-03', 'tweet'),
(10, 2, '2023-06-04', 'tweet'),

-- user 3  →  most common = 'purchase' (2 purchases vs 1 click)
(11, 3, '2023-06-01', 'purchase'),
(12, 3, '2023-06-02', 'purchase'),
(13, 3, '2023-06-03', 'click'),

-- user 4  →  most common = 'login' (4 logins)
(14, 4, '2023-06-01', 'login'),
(15, 4, '2023-06-02', 'login'),
(16, 4, '2023-06-03', 'login'),
(17, 4, '2023-06-04', 'login'),

-- user 5  →  equal login & purchase (tie scenario)
(18, 5, '2023-06-01', 'login'),
(19, 5, '2023-06-01', 'purchase'),
(20, 5, '2023-06-02', 'login'),
(21, 5, '2023-06-02', 'purchase'),

-- user 6  →  most common = 'tweet'
(22, 6, '2023-06-01', 'tweet'),
(23, 6, '2023-06-02', 'tweet'),
(24, 6, '2023-06-03', 'click'),

-- user 7  →  login + purchase
(25, 7, '2023-06-01', 'login'),
(26, 7, '2023-06-02', 'purchase'),
(27, 7, '2023-06-03', 'login'),

-- user 8  →  click only
(28, 8, '2023-06-01', 'click'),
(29, 8, '2023-06-02', 'click'),

-- user 10  →  login + purchase
(30, 10, '2023-06-01', 'login'),
(31, 10, '2023-06-01', 'purchase'),
(32, 10, '2023-06-02', 'login');


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
