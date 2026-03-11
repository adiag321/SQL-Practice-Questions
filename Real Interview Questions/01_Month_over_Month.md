# Month-over-Month (MoM) MAU Growth Calculation

This document explains a SQL script that calculates the month-over-month (MoM) growth rate for Monthly Active Users (MAU). This is a common metric used to understand user engagement and business growth.

```sql
-- Create the table to hold user activity data
CREATE TABLE user_activity (
    user_id INT,
    date DATE
);

INSERT INTO user_activity (user_id, date) VALUES
(1, '2018-07-01'),
(234, '2018-07-02'),
(3, '2018-07-02'),
(1, '2018-07-02'),
(1, '2018-07-15'),
(234, '2018-07-20'),
(3, '2018-07-25'),
(5, '2018-07-28'),
(1, '2018-08-01'),
(234, '2018-08-05'),
(5, '2018-08-10'),
(6, '2018-08-15'),
(7, '2018-08-20'),
(1, '2018-09-01'),
(3, '2018-09-05'),
(5, '2018-09-10'),
(6, '2018-09-15'),
(8, '2018-09-20'),
(9, '2018-09-25'),
(234, '2018-10-01'),
(1, '2018-10-02'),
(5, '2018-10-03'),
(234, '2018-10-04');

```

## Sample Input Data

The query uses the following sample data from the `user_activity` table:

| user_id | date       |
|---------|------------|
| 1       | 2018-07-01 |
| 234     | 2018-07-02 |
| 3       | 2018-07-02 |
| ...     | ...        |

## Expected Output

Running the script against the sample data will produce the following result:

| month                   | mau | previous_mau | percentage_change |
|-------------------------|-----|--------------|-------------------|
| 2018-08-01 00:00:00.000 | 5   | 4            | 25.00             |
| 2018-09-01 00:00:00.000 | 6   | 5            | 20.00             |
| 2018-10-01 00:00:00.000 | 3   | 6            | -50.00            |

## Solution

```sql
-- This CTE calculates the Monthly Active Users (MAU)
WITH monthly_active_users AS (
  SELECT 
    -- Truncate the date to the first day of the month to group by month
    DATE_TRUNC('month', date) AS month,
    -- Count the number of distinct users to get the MAU
    COUNT(DISTINCT user_id) AS mau
  FROM 
    user_activity
  GROUP BY 
    DATE_TRUNC('month', date)
),
-- This CTE retrieves the MAU of the previous month
mau_with_previous AS (
  SELECT 
    month,
    mau,
    -- Use the LAG window function to get the MAU from the previous row (which is the previous month)
    LAG(mau) OVER (ORDER BY month) AS previous_mau
  FROM 
    monthly_active_users
)
-- Final SELECT statement to calculate the percentage change
SELECT 
  month,
  mau,
  previous_mau,
  -- Calculate the percentage change and round it to 2 decimal places
  ROUND((mau - previous_mau) * 100.0 / previous_mau, 2) AS percentage_change
FROM 
  mau_with_previous
-- Exclude the first month where there is no previous data
WHERE 
  previous_mau IS NOT NULL
ORDER BY 
  month;
```

## How it Works

The query operates in several stages:

1.  **Table Creation and Data Insertion**: A table `user_activity` is created with `user_id` and `date` columns. Sample data is inserted to simulate user activity over a few months.

2.  **Monthly Active Users (MAU) Calculation**:
    *   The `monthly_active_users` CTE groups the records by month.
    *   `DATE_TRUNC('month', date)` is used to standardize the date to the first day of the month for each record.
    *   `COUNT(DISTINCT user_id)` calculates the number of unique users for that month, which is the MAU.

3.  **Fetching Previous Month's MAU**:
    *   The `mau_with_previous` CTE uses the `LAG()` window function.
    *   `LAG(mau) OVER (ORDER BY month)` retrieves the `mau` value from the previous month.

4.  **Final Calculation**:
    *   The final `SELECT` statement computes the percentage change using the formula: `((current_mau - previous_mau) / previous_mau) * 100`.
    *   `ROUND()` is used to format the result to two decimal places.
    *   The `WHERE previous_mau IS NOT NULL` clause filters out the first month, for which there is no prior month data to compare against.