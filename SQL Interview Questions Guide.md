# SQL Interview Questions Guide: Unified Reference

Welcome to the ultimate SQL Interview Questions Guide. This document contains standard PostgreSQL schemas, mock datasets, and 28 interview-level questions organized across 8 core topics. 

---

## Table of Contents

- [1. Core Aggregations](#1-core-aggregations)
  - [Revenue by Customer](#revenue-by-customer)
  - [Average Order Value by Region](#average-order-value-by-region)
  - [Count Active Users by Day](#count-active-users-by-day)
  - [Number of Failed Jobs by Service](#number-of-failed-jobs-by-service)
- [2. Joins and Null Handling](#2-joins-and-null-handling)
  - [Users with No Orders](#users-with-no-orders)
  - [Orders with Customer Metadata](#orders-with-customer-metadata)
  - [Products Never Purchased](#products-never-purchased)
  - [Combine Fact and Dimension Tables](#combine-fact-and-dimension-tables)
- [3. Deduplication and Latest-Row Logic](#3-deduplication-and-latest-row-logic)
  - [Keep the Latest Status per User](#keep-the-latest-status-per-user)
  - [Remove Duplicate Transactions](#remove-duplicate-transactions)
  - [Select the Most Recent Model Run](#select-the-most-recent-model-run)
- [4. Ranking and Top-N Per Group](#4-ranking-and-top-n-per-group)
  - [Top 3 Products per Category](#top-3-products-per-category)
  - [Highest Revenue User per Country](#highest-revenue-user-per-country)
  - [Top Model per Experiment](#top-model-per-experiment)
- [5. Window Functions](#5-window-functions)
  - [Running Revenue by Day](#running-revenue-by-day)
  - [Compare Each Event to the Previous Event](#compare-each-event-to-the-previous-event)
  - [Rolling 7-Day Average](#rolling-7-day-average)
  - [Detect Changes in User Behavior](#detect-changes-in-user-behavior)
- [6. Time Bucketing and Cohort Logic](#6-time-bucketing-and-cohort-logic)
  - [Monthly Active Users](#monthly-active-users)
  - [Week-1 Retention](#week-1-retention)
  - [Cohort Revenue by Signup Month](#cohort-revenue-by-signup-month)
  - [Daily Model Inference Counts](#daily-model-inference-counts)
- [7. Funnel and Conversion Queries](#7-funnel-and-conversion-queries)
  - [View -> Click -> Purchase Funnel](#view---click---purchase-funnel)
  - [Signup -> Activation -> Subscription](#signup---activation---subscription)
  - [Experiment Exposure -> Conversion](#experiment-exposure---conversion)
- [8. Clean Query Design with CTEs](#8-clean-query-design-with-ctes)
  - [Messy Analytics Question with Multiple Joins](#messy-analytics-question-with-multiple-joins)
  - [Retention Question with Several Business Rules](#retention-question-with-several-business-rules)
  - [Interviewers Asking You to "Make It Cleaner"](#interviewers-asking-you-to-make-it-cleaner)
- [Common Mistakes](#common-mistakes)

---

## Database Schemas & Seeding DDL

### Schema 1: E-Commerce & Transactions
```sql
-- Create tables
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    signup_date DATE NOT NULL,
    country VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE user_status_history (
    history_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    region VARCHAR(50) NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);

CREATE TABLE transactions (
    transaction_id INT,
    order_id INT NOT NULL,
    transaction_timestamp TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

INSERT INTO users (user_id, signup_date, country, region) VALUES
(1, '2026-05-01', 'USA', 'North'),
(2, '2026-05-03', 'USA', 'South'),
(3, '2026-05-05', 'CAN', 'East'),
(4, '2026-05-10', 'GBR', 'West'),
(5, '2026-06-01', 'USA', 'North'),
(6, '2026-06-02', 'CAN', 'West'),
(7, '2026-06-05', 'GBR', 'East');

INSERT INTO user_status_history (user_id, status, updated_at) VALUES
(1, 'Pending', '2026-05-01 10:00:00'),
(1, 'Active', '2026-05-01 12:00:00'),
(1, 'Suspended', '2026-05-05 14:00:00'),
(2, 'Pending', '2026-05-03 09:00:00'),
(2, 'Active', '2026-05-03 11:00:00'),
(3, 'Pending', '2026-05-05 08:00:00'),
(4, 'Pending', '2026-05-10 10:00:00'),
(4, 'Active', '2026-05-11 09:00:00');

INSERT INTO products (product_id, name, category, price) VALUES
(101, 'Laptop', 'Electronics', 1200.00),
(102, 'Smartphone', 'Electronics', 800.00),
(103, 'Jeans', 'Apparel', 60.00),
(104, 'T-Shirt', 'Apparel', 25.00),
(105, 'Novel', 'Books', 15.00),
(106, 'Textbook', 'Books', 90.00);

INSERT INTO orders (order_id, user_id, order_date, total_amount, region) VALUES
(1001, 1, '2026-05-02', 1260.00, 'North'),
(1002, 1, '2026-05-06', 25.00, 'North'),
(1003, 2, '2026-05-04', 800.00, 'South'),
(1004, 3, '2026-05-06', 150.00, 'East'),
(1005, 5, '2026-06-03', 1200.00, 'North'),
(1006, 6, '2026-06-04', 120.00, 'West'),
(1007, 2, '2026-05-15', 60.00, 'South');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, price) VALUES
(5001, 1001, 101, 1, 1200.00),
(5002, 1001, 103, 1, 60.00),
(5003, 1002, 104, 1, 25.00),
(5004, 1003, 102, 1, 800.00),
(5005, 1004, 103, 1, 60.00),
(5006, 1004, 105, 6, 15.00),
(5007, 1005, 101, 1, 1200.00),
(5008, 1006, 103, 2, 60.00),
(5009, 1007, 103, 1, 60.00);

INSERT INTO transactions (transaction_id, order_id, transaction_timestamp, status, amount) VALUES
(2001, 1001, '2026-05-02 10:05:00', 'Success', 1260.00),
(2001, 1001, '2026-05-02 10:05:00', 'Success', 1260.00), -- Duplicate record
(2002, 1002, '2026-05-06 14:30:00', 'Failed', 25.00),
(2003, 1002, '2026-05-06 14:32:00', 'Success', 25.00),
(2004, 1003, '2026-05-04 11:10:00', 'Success', 800.00),
(2004, 1003, '2026-05-04 11:10:00', 'Success', 800.00), -- Duplicate record
(2005, 1004, '2026-05-06 09:15:00', 'Success', 150.00);
```

### Schema 2: System Logs, Jobs & Experiments
```sql
-- Create tables
CREATE TABLE job_runs (
    job_id INT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE model_runs (
    run_id INT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    experiment_id INT NOT NULL,
    metrics_score DECIMAL(5, 4) NOT NULL,
    run_timestamp TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL
);

CREATE TABLE model_inferences (
    inference_id INT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    inference_timestamp TIMESTAMP NOT NULL
);

INSERT INTO job_runs (job_id, service_name, status, created_at) VALUES
(3001, 'payment-service', 'SUCCESS', '2026-06-08 00:01:00'),
(3002, 'payment-service', 'FAILED', '2026-06-08 00:05:00'),
(3003, 'notification-service', 'FAILED', '2026-06-08 00:10:00'),
(3004, 'payment-service', 'FAILED', '2026-06-08 01:00:00'),
(3005, 'notification-service', 'SUCCESS', '2026-06-08 01:15:00'),
(3006, 'recommendation-service', 'SUCCESS', '2026-06-08 02:00:00');

INSERT INTO model_runs (run_id, model_name, experiment_id, metrics_score, run_timestamp, status) VALUES
(4001, 'xgboost-v1', 1001, 0.8500, '2026-06-01 10:00:00', 'Success'),
(4002, 'xgboost-v2', 1001, 0.8900, '2026-06-02 12:00:00', 'Success'),
(4003, 'lightgbm-v1', 1001, 0.9100, '2026-06-03 14:00:00', 'Success'),
(4004, 'randomforest-v1', 1002, 0.7800, '2026-06-01 09:00:00', 'Success'),
(4005, 'randomforest-v2', 1002, 0.8200, '2026-06-02 11:00:00', 'Success'),
(4006, 'xgboost-v2', 1001, 0.7000, '2026-06-04 15:00:00', 'Failed');

INSERT INTO model_inferences (inference_id, model_name, inference_timestamp) VALUES
(6001, 'lightgbm-v1', '2026-06-08 10:00:00'),
(6002, 'lightgbm-v1', '2026-06-08 10:05:00'),
(6003, 'randomforest-v2', '2026-06-08 11:00:00'),
(6004, 'lightgbm-v1', '2026-06-09 09:00:00'),
(6005, 'randomforest-v2', '2026-06-09 09:15:00');
```

### Schema 3: Event Logs & Funnel Events
```sql
-- Create tables
CREATE TABLE user_events (
    event_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_timestamp TIMESTAMP NOT NULL,
    experiment_group VARCHAR(50) NOT NULL,
    device VARCHAR(50) NOT NULL
);

INSERT INTO user_events (event_id, user_id, event_type, event_timestamp, experiment_group, device) VALUES
(7001, 1, 'view', '2026-06-08 10:00:00', 'control', 'mobile'),
(7002, 1, 'click', '2026-06-08 10:01:00', 'control', 'mobile'),
(7003, 1, 'purchase', '2026-06-08 10:05:00', 'control', 'mobile'),
(7004, 2, 'view', '2026-06-08 10:10:00', 'treatment', 'desktop'),
(7005, 2, 'click', '2026-06-08 10:12:00', 'treatment', 'desktop'),
(7006, 3, 'view', '2026-06-08 10:20:00', 'control', 'mobile'),
(7007, 4, 'signup', '2026-06-08 11:00:00', 'control', 'desktop'),
(7008, 4, 'activation', '2026-06-08 11:30:00', 'control', 'desktop'),
(7009, 4, 'subscription', '2026-06-09 09:00:00', 'control', 'desktop'),
(7010, 5, 'signup', '2026-06-08 12:00:00', 'treatment', 'mobile'),
(7011, 5, 'activation', '2026-06-08 13:00:00', 'treatment', 'mobile'),
(7012, 6, 'signup', '2026-06-08 14:00:00', 'treatment', 'desktop'),
(7013, 1, 'view', '2026-06-09 10:00:00', 'control', 'mobile'),
(7014, 2, 'view', '2026-06-09 11:00:00', 'treatment', 'desktop'),
(7015, 5, 'view', '2026-06-08 12:05:00', 'treatment', 'desktop'),
(7016, 1, 'view', '2026-05-09 14:00:00', 'control', 'mobile'),
(7017, 2, 'view', '2026-05-11 15:30:00', 'treatment', 'desktop');
```

---

## 1. Core Aggregations

### Revenue by Customer
**Question**: Write a query to find the total revenue generated by each customer. Include customers who have not placed any orders, representing their spend as `0`.

#### Answer
```sql
SELECT 
    u.user_id,
    u.country,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.country
ORDER BY total_revenue DESC;
```

---

### Average Order Value by Region
**Question**: Write a query to calculate the average order value (AOV) and total number of orders grouped by region, sorted in descending order of AOV.

#### Answer
```sql
SELECT 
    region,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY region
ORDER BY avg_order_value DESC;
```
---

### Count Active Users by Day
**Question**: Write a query to find the count of unique active users for each day.

#### Answer
```sql
SELECT 
    DATE(event_timestamp) AS activity_date,
    COUNT(DISTINCT user_id) AS active_users
FROM user_events
GROUP BY activity_date
ORDER BY activity_date;
```

---

### Number of Failed Jobs by Service
**Question**: Write a query to find the number of failed jobs for each service, ordered by the number of failures in descending order.

#### Answer
```sql
SELECT 
    service_name,
    COUNT(*) AS failed_jobs_count
FROM job_runs
WHERE status = 'FAILED'
GROUP BY service_name
ORDER BY failed_jobs_count DESC;
```

---

## 2. Joins and Null Handling

### Users with No Orders
**Question**: Identify all registered users who have never placed an order.

#### Answer
```sql
SELECT 
    u.user_id,
    u.signup_date,
    u.country
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.order_id IS NULL;
```

---

### Orders with Customer Metadata
**Question**: Retrieve all orders along with the country and region of the customer who placed them.

#### Answer
```sql
SELECT 
    o.order_id,
    o.order_date,
    o.total_amount,
    u.country,
    u.region AS customer_region
FROM orders o
INNER JOIN users u ON o.user_id = u.user_id;
```

---

### Products Never Purchased
**Question**: Find all products that have never been included in any order.

#### Answer
```sql
SELECT 
    p.product_id,
    p.name,
    p.category
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
```

---

### Combine Fact and Dimension Tables
**Question**: Calculate total item-level revenue by combining order facts and customer/product dimensions. Output the items, order dates, customer countries, product names, categories, and calculated revenue.

#### Answer
```sql
SELECT 
    oi.order_item_id,
    o.order_date,
    u.country AS customer_country,
    p.name AS product_name,
    p.category AS product_category,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS item_revenue
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN users u ON o.user_id = u.user_id
INNER JOIN products p ON oi.product_id = p.product_id;
```

---

## 3. Deduplication and Latest-Row Logic

### Keep the Latest Status per User
**Question**: Retrieve the most recent status record for each user from the status history log.

#### Answer
```sql
WITH ranked_statuses AS (
    SELECT 
        user_id,
        status,
        updated_at,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY updated_at DESC) as rn
    FROM user_status_history
)
SELECT 
    user_id,
    status,
    updated_at
FROM ranked_statuses
WHERE rn = 1;
```

---

### Remove Duplicate Transactions
**Question**: Write a query to deduplicate the transactions table. An exact duplicate represents identical transaction id, order id, timestamp, status, and amount. Keep only one instance of duplicate transactions.

#### Answer
```sql
WITH deduplicated AS (
    SELECT 
        transaction_id,
        order_id,
        transaction_timestamp,
        status,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY transaction_id, order_id, transaction_timestamp, status, amount 
            ORDER BY transaction_timestamp
        ) AS rn
    FROM transactions
)
SELECT 
    transaction_id,
    order_id,
    transaction_timestamp,
    status,
    amount
FROM deduplicated
WHERE rn = 1;
```

---

### Select the Most Recent Model Run
**Question**: Find the details of the most recent model execution run for each unique model name.

#### Answer
```sql
WITH ranked_runs AS (
    SELECT 
        run_id,
        model_name,
        experiment_id,
        metrics_score,
        run_timestamp,
        status,
        ROW_NUMBER() OVER (PARTITION BY model_name ORDER BY run_timestamp DESC) AS rn
    FROM model_runs
)
SELECT 
    run_id,
    model_name,
    experiment_id,
    metrics_score,
    run_timestamp,
    status
FROM ranked_runs
WHERE rn = 1;
```

---

## 4. Ranking and Top-N Per Group

### Top 3 Products per Category
**Question**: For each product category, find the top 3 best-selling products by quantity sold.

#### Answer
```sql
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.name,
        p.category,
        COALESCE(SUM(oi.quantity), 0) AS units_sold,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity) DESC) AS sales_rank
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.name, p.category
)
SELECT 
    product_id,
    name,
    category,
    units_sold,
    sales_rank
FROM product_sales
WHERE sales_rank <= 3;
```

---

### Highest Revenue User per Country
**Question**: Find the user who has spent the most money in each country.

#### Answer
```sql
WITH user_revenue AS (
    SELECT 
        u.user_id,
        u.country,
        COALESCE(SUM(o.total_amount), 0) AS total_revenue,
        RANK() OVER (PARTITION BY u.country ORDER BY SUM(o.total_amount) DESC) AS rank
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.user_id, u.country
)
SELECT 
    user_id,
    country,
    total_revenue
FROM user_revenue
WHERE rank = 1;
```

---

### Top Model per Experiment
**Question**: For each experiment, select the model run with the highest metrics score that executed successfully.

#### Answer
```sql
WITH ranked_models AS (
    SELECT 
        run_id,
        model_name,
        experiment_id,
        metrics_score,
        ROW_NUMBER() OVER (PARTITION BY experiment_id ORDER BY metrics_score DESC) AS rn
    FROM model_runs
    WHERE status = 'Success'
)
SELECT 
    experiment_id,
    run_id,
    model_name,
    metrics_score
FROM ranked_models
WHERE rn = 1;
```

---

## 5. Window Functions

### Running Revenue by Day
**Question**: Write a query to calculate the running (cumulative) sum of daily revenue.

#### Answer
```sql
WITH daily_revenue AS (
    SELECT 
        order_date,
        SUM(total_amount) AS daily_rev
    FROM orders
    GROUP BY order_date
)
SELECT 
    order_date,
    daily_rev,
    SUM(daily_rev) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_revenue
FROM daily_revenue
ORDER BY order_date;
```

---

### Compare Each Event to the Previous Event
**Question**: For each clickstream event, retrieve the current event details, the type of the previous event, and the time difference in seconds between them.

#### Answer
```sql
WITH lag_events AS (
    SELECT 
        event_id,
        user_id,
        event_type,
        event_timestamp,
        LAG(event_type) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS prev_event_type,
        LAG(event_timestamp) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS prev_event_timestamp
    FROM user_events
)
SELECT 
    event_id,
    user_id,
    event_type,
    event_timestamp,
    prev_event_type,
    EXTRACT(EPOCH FROM (event_timestamp - prev_event_timestamp)) AS seconds_since_prev
FROM lag_events;
```

---

### Rolling 7-Day Average
**Question**: Write a query to find the rolling 7-day average of daily revenue.

#### Answer
```sql
WITH daily_revenue AS (
    SELECT 
        order_date,
        SUM(total_amount) AS daily_rev
    FROM orders
    GROUP BY order_date
)
SELECT 
    order_date,
    daily_rev,
    ROUND(AVG(daily_rev) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_7d_avg
FROM daily_revenue
ORDER BY order_date;
```

---

### Detect Changes in User Behavior
**Question**: Write a query to detect instances where a user switched their device type between consecutive actions.

#### Answer
```sql
WITH behavior_lead AS (
    SELECT 
        user_id,
        event_type,
        device,
        event_timestamp,
        LEAD(device) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS next_device
    FROM user_events
)
SELECT 
    user_id,
    event_timestamp AS original_event_time,
    device AS original_device,
    next_device AS switched_to_device
FROM behavior_lead
WHERE next_device IS NOT NULL AND device != next_device;
```

---

## 6. Time Bucketing and Cohort Logic

### Monthly Active Users
**Question**: Write a query to calculate Monthly Active Users (MAU).

#### Answer
```sql
SELECT 
    DATE_TRUNC('month', event_timestamp) AS cohort_month,
    COUNT(DISTINCT user_id) AS mau
FROM user_events
GROUP BY cohort_month
ORDER BY cohort_month;
```

---

### Week-1 Retention
**Question**: Calculate week-1 cohort retention. The cohort is defined by user signup week. Retained users are those active between 7 and 13 days after signup.

#### Answer
```sql
WITH signups AS (
    SELECT 
        user_id,
        signup_date
    FROM users
),
active_events AS (
    SELECT DISTINCT 
        user_id,
        DATE(event_timestamp) AS activity_date
    FROM user_events
)
SELECT 
    DATE_TRUNC('week', s.signup_date)::date AS signup_week,
    COUNT(DISTINCT s.user_id) AS cohort_size,
    COUNT(DISTINCT CASE WHEN ae.activity_date::date - s.signup_date::date BETWEEN 7 AND 13 THEN s.user_id END) AS retained_week_1,
    ROUND(
        COUNT(DISTINCT CASE WHEN ae.activity_date::date - s.signup_date::date BETWEEN 7 AND 13 THEN s.user_id END) * 100.0 / 
        COUNT(DISTINCT s.user_id), 
        2
    ) AS week_1_retention_pct
FROM signups s
LEFT JOIN active_events ae ON s.user_id = ae.user_id
GROUP BY signup_week
ORDER BY signup_week;
```

---

### Cohort Revenue by Signup Month
**Question**: Track cohort lifetime spending. Group users by signup month, and find their total spent and Average Revenue Per User (ARPU) for subsequent order months.

#### Answer
```sql
WITH user_signup_cohort AS (
    SELECT 
        user_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM users
),
order_revenue AS (
    SELECT 
        user_id,
        DATE_TRUNC('month', order_date) AS order_month,
        SUM(total_amount) AS monthly_revenue
    FROM orders
    GROUP BY user_id, order_month
)
SELECT 
    c.cohort_month,
    r.order_month,
    COUNT(DISTINCT c.user_id) AS cohort_users,
    SUM(r.monthly_revenue) AS total_revenue,
    ROUND(SUM(r.monthly_revenue) / COUNT(DISTINCT c.user_id), 2) AS arpu
FROM user_signup_cohort c
LEFT JOIN order_revenue r ON c.user_id = r.user_id
GROUP BY c.cohort_month, r.order_month
ORDER BY c.cohort_month, r.order_month;
```

---

### Daily Model Inference Counts
**Question**: Write a query to find the daily inference count grouped by model name.

#### Answer
```sql
SELECT 
    DATE_TRUNC('day', inference_timestamp) AS inference_date,
    model_name,
    COUNT(*) AS total_inferences
FROM model_inferences
GROUP BY inference_date, model_name
ORDER BY inference_date, model_name;
```

---

## 7. Funnel and Conversion Queries

### View -> Click -> Purchase Funnel
**Question**: Write a query to find the conversion rates across the three standard funnel stages: `view` -> `click` -> `purchase`.

#### Answer
```sql
WITH event_steps AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS stage_1_view,
        MAX(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS stage_2_click,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS stage_3_purchase
    FROM user_events
    GROUP BY user_id
)
SELECT 
    SUM(stage_1_view) AS total_views,
    SUM(stage_2_click) AS total_clicks,
    SUM(stage_3_purchase) AS total_purchases,
    ROUND(SUM(stage_2_click) * 100.0 / SUM(stage_1_view), 2) AS view_to_click_conv_pct,
    ROUND(SUM(stage_3_purchase) * 100.0 / SUM(stage_2_click), 2) AS click_to_purchase_conv_pct,
    ROUND(SUM(stage_3_purchase) * 100.0 / SUM(stage_1_view), 2) AS overall_conv_pct
FROM event_steps;
```

---

### Signup -> Activation -> Subscription
**Question**: Track the customer conversion lifecycle from signup, to activation, to subscription. Calculate activation rate, subscription rate (from active), and overall conversion rate.

#### Answer
```sql
WITH user_stages AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) AS step_1_signup,
        MAX(CASE WHEN event_type = 'activation' THEN 1 ELSE 0 END) AS step_2_activation,
        MAX(CASE WHEN event_type = 'subscription' THEN 1 ELSE 0 END) AS step_3_subscription
    FROM user_events
    GROUP BY user_id
)
SELECT 
    SUM(step_1_signup) AS signups,
    SUM(step_2_activation) AS activations,
    SUM(step_3_subscription) AS subscriptions,
    ROUND(SUM(step_2_activation) * 100.0 / SUM(step_1_signup), 2) AS activation_pct,
    ROUND(SUM(step_3_subscription) * 100.0 / SUM(step_2_activation), 2) AS subscription_pct,
    ROUND(SUM(step_3_subscription) * 100.0 / SUM(step_1_signup), 2) AS conversion_rate_pct
FROM user_stages
WHERE step_1_signup = 1;
```

---

### Experiment Exposure -> Conversion
**Question**: Analyze conversion rates partitioned by experiment groups (`control` vs `treatment`).

#### Answer
```sql
WITH users_in_exp AS (
    SELECT DISTINCT 
        user_id,
        experiment_group
    FROM user_events
),
user_purchases AS (
    SELECT DISTINCT 
        user_id
    FROM user_events
    WHERE event_type = 'purchase'
)
SELECT 
    exp.experiment_group,
    COUNT(DISTINCT exp.user_id) AS exposed_users,
    COUNT(DISTINCT p.user_id) AS converted_users,
    ROUND(COUNT(DISTINCT p.user_id) * 100.0 / COUNT(DISTINCT exp.user_id), 2) AS conversion_rate_pct
FROM users_in_exp exp
LEFT JOIN user_purchases p ON exp.user_id = p.user_id
GROUP BY exp.experiment_group;
```

---

## 8. Clean Query Design with CTEs

### Messy Analytics Question with Multiple Joins
**Question**: Write a clean, readable query that joins multiple tables to report active users, total orders, total revenue, and average order value (AOV) grouped by country and region.

#### Answer
```sql
WITH customer_orders AS (
    SELECT 
        user_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY user_id
),
customer_demographics AS (
    SELECT 
        user_id,
        country,
        region
    FROM users
)
SELECT 
    d.country,
    d.region,
    COUNT(DISTINCT d.user_id) AS customer_count,
    COALESCE(SUM(o.total_orders), 0) AS total_orders,
    COALESCE(SUM(o.total_spent), 0) AS total_revenue,
    ROUND(COALESCE(SUM(o.total_spent), 0) / NULLIF(SUM(o.total_orders), 0), 2) AS aov
FROM customer_demographics d
LEFT JOIN customer_orders o ON d.user_id = o.user_id
GROUP BY d.country, d.region
ORDER BY total_revenue DESC;
```

---

### Retention Question with Several Business Rules
**Question**: Classify users based on rules:
1. "Power User": Spent > $1000 and had at least 2 active days.
2. "Active User": Spent > $0 or had at least 1 active day.
3. "Churned": All others.
Report the count and average spending for each user segment.

#### Answer
```sql
WITH user_activity_counts AS (
    SELECT 
        user_id,
        COUNT(DISTINCT DATE(event_timestamp)) AS active_days
    FROM user_events
    GROUP BY user_id
),
user_total_spending AS (
    SELECT 
        user_id,
        SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY user_id
),
user_segmentation AS (
    SELECT 
        u.user_id,
        u.country,
        COALESCE(a.active_days, 0) AS active_days,
        COALESCE(s.total_spent, 0) AS total_spent,
        CASE 
            WHEN COALESCE(s.total_spent, 0) > 1000 AND COALESCE(a.active_days, 0) >= 2 THEN 'Power User'
            WHEN COALESCE(s.total_spent, 0) > 0 OR COALESCE(a.active_days, 0) > 0 THEN 'Active User'
            ELSE 'Churned'
        END AS user_segment
    FROM users u
    LEFT JOIN user_activity_counts a ON u.user_id = a.user_id
    LEFT JOIN user_total_spending s ON u.user_id = s.user_id
)
SELECT 
    user_segment,
    COUNT(*) AS user_count,
    ROUND(AVG(total_spent), 2) AS avg_spent_per_segment
FROM user_segmentation
GROUP BY user_segment
ORDER BY user_count DESC;
```

---

### Interviewers Asking You to "Make It Cleaner"
**Question**: Show a comparison of a messy, deeply nested subquery versus a clean refactored CTE structure that aggregates country-level sales details.

#### The Messy Approach (To Avoid)
```sql
-- Hard to read, maintain, or debug
SELECT 
    u.country, 
    COUNT(DISTINCT u.user_id) AS total_users, 
    sum_data.total_spent
FROM users u 
LEFT JOIN (
    SELECT user_id, SUM(total_amount) AS total_spent 
    FROM orders 
    GROUP BY user_id
) sum_data ON u.user_id = sum_data.user_id
GROUP BY u.country, sum_data.total_spent;
```

#### The Clean Refactored CTE Approach (Recommended)
```sql
WITH order_details AS (
    SELECT 
        o.user_id,
        COUNT(DISTINCT o.order_id) AS num_orders,
        SUM(oi.quantity) AS num_items,
        SUM(o.total_amount) AS total_spent
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.user_id
),
user_profiles AS (
    SELECT 
        user_id,
        country,
        region,
        signup_date
    FROM users
)
SELECT 
    p.country,
    COUNT(DISTINCT p.user_id) AS total_registered_users,
    COUNT(DISTINCT od.user_id) AS active_purchasers,
    COALESCE(SUM(od.num_orders), 0) AS total_orders,
    COALESCE(SUM(od.num_items), 0) AS total_items_sold,
    COALESCE(SUM(od.total_spent), 0) AS total_sales,
    ROUND(COALESCE(SUM(od.total_spent), 0) / NULLIF(SUM(od.num_orders), 0), 2) AS avg_order_value
FROM user_profiles p
LEFT JOIN order_details od ON p.user_id = od.user_id
GROUP BY p.country
ORDER BY total_sales DESC;
```

---

## Common Mistakes

### 1. Using `COUNT(*)` when `COUNT(DISTINCT user_id)` is needed
* **Mistake**: Counting total transactions or raw rows instead of unique users, leading to inflated metrics.
* **Example**:
  * **Incorrect**: `SELECT DATE(event_timestamp), COUNT(*) FROM user_events GROUP BY 1;` (If User 1 click 10 times, count is 10)
  * **Correct**: `SELECT DATE(event_timestamp), COUNT(DISTINCT user_id) FROM user_events GROUP BY 1;` (If User 1 click 10 times, count is 1)

### 2. Filtering after a `LEFT JOIN` in a way that turns it into an `INNER JOIN`
* **Mistake**: Placing filters on the right-side table in the `WHERE` clause. Since `NULL` comparison fails the condition, it filters out all rows where no match occurred.
* **Example**:
  * **Incorrect**: `SELECT u.user_id FROM users u LEFT JOIN orders o ON u.user_id = o.user_id WHERE o.status = 'Completed';` (Drops users with 0 orders because `o.status` evaluates to `NULL` for them, which is not equal to `'Completed'`)
  * **Correct**: `SELECT u.user_id FROM users u LEFT JOIN orders o ON u.user_id = o.user_id AND o.status = 'Completed';`

### 3. Forgetting the data grain before aggregation
* **Mistake**: Joining tables of different granularities (e.g., one-to-many relationship) and calculating sums directly, resulting in double-counting values.
* **Example**:
  * **Incorrect**: `SELECT u.user_id, SUM(o.total_amount) FROM users u JOIN orders o ON u.user_id = o.user_id JOIN order_items oi ON o.order_id = oi.order_id GROUP BY 1;` (If an order has 3 items, `o.total_amount` is added 3 times)
  * **Correct**: Aggregate orders first to the user grain in a CTE *before* performing joins or calculations.

### 4. Using `rank()` when `row_number()` is required
* **Mistake**: Using `RANK()` for deduplication when ties exist. Ties receive the identical ranking, leaving duplicate records in the deduplicated subset.
* **Example**:
  * **Incorrect**: `WITH r AS (SELECT user_id, RANK() OVER (PARTITION BY user_id ORDER BY updated_at DESC) as rn FROM status_history) SELECT * FROM r WHERE rn = 1;` (If two rows have the identical newest timestamp, both receive rank 1 and both are returned)
  * **Correct**: Use `ROW_NUMBER() OVER (...)` to guarantee exactly one row receives `1`.

### 5. Mixing event-level rows with user-level metrics without a normalization step
* **Mistake**: Computing user-level metrics (e.g., average account age) directly from the transaction/event log, which biases calculations towards users with higher event volumes.
* **Example**:
  * **Incorrect**: `SELECT AVG(CURRENT_DATE - u.signup_date) FROM user_events e JOIN users u ON e.user_id = u.user_id;` (Frequent clickers heavily weight the average age calculation)
  * **Correct**: Deduplicate or aggregate events to the user level first, then compute the average.

### 6. Ordering windows incorrectly
* **Mistake**: Omitting `ORDER BY` inside a window partition when a sequential sum/operation is needed, or applying sorting fields out of sequence.
* **Example**:
  * **Incorrect**: `SELECT order_date, SUM(amount) OVER (PARTITION BY user_id) FROM orders;` (Returns the sum of all orders for the user on every line, not a running sum)
  * **Correct**: `SELECT order_date, SUM(amount) OVER (PARTITION BY user_id ORDER BY order_date) FROM orders;`
