-- Day 10/30 SQL Interview Question - Medium
/*
Write an SQL query to find for each month and country, the number of transactions and their total amount, 
the number of approved transactions and their total amount.
Return the result table in in below order

Output: 
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+
*/

CREATE TABLE Transactions (
    id INT PRIMARY KEY,
    country VARCHAR(255),
    state VARCHAR,
    amount INT,
    trans_date DATE
);

INSERT INTO Transactions (id, country, state, amount, trans_date) VALUES
(121, 'US', 'approved', 1000, '2018-12-18'),
(122, 'US', 'declined', 2000, '2018-12-19'),
(123, 'US', 'approved', 2000, '2019-01-01'),
(124, 'DE', 'approved', 2000, '2019-01-07'),
(125, 'IN', 'declined', 3000, '2019-02-10'),
(126, 'IN', 'approved', 4000, '2019-02-17'),
(127, 'IN', 'approved', 5000, '2019-02-21');

-- -------------------------------------------------------------
-- My Solution
-- -------------------------------------------------------------

-- Solution 1:
SELECT 
	TO_CHAR(trans_date, 'YYYY-MM') as month,
	country,
	COUNT(1) as trans_count,
	SUM(CASE WHEN state='approved' THEN 1 ELSE 0 END) as approved_count,
	SUM(amount) as trans_total_amount,
	SUM(CASE WHEN state= 'approved' THEN amount ELSE 0 END) as approved_total_amount
FROM transactions
GROUP BY 1, 2;

-- Solution 2:
select
extract(month from trans_date) as month,
country,
count(distinct id) as trans_count,
sum(case when state = 'approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
from transactions
group by 1, 2;

