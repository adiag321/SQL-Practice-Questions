-- 26/30 Days SQL Challenge
/*
-- Amazon Data Analyst Interview (Hard Category Questions)

Question:
Suppose you are given two tables - Orders and Returns. 
The Orders table contains information about orders placed by customers, 
and the Returns table contains information about returned items. 

Design a SQL query to find the top 5 customer with the highest percentage of returned items 
out of their total orders. 
Return the customer ID and the percentage of returned items rounded to two decimal places.
*/

CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    total_items_ordered INT
);

INSERT INTO orders VALUES
(1, 101, '2022-01-01', 5),
(16, 101, '2022-01-16', 8),
(17, 101, '2022-01-20', 12),
(2, 102, '2022-01-02', 10),
(18, 102, '2022-01-18', 15),
(19, 102, '2022-01-25', 20),
(3, 103, '2022-01-03', 8),
(20, 103, '2022-01-17', 10),
(4, 104, '2022-01-04', 12),
(5, 105, '2022-01-05', 15),
(21, 105, '2022-01-22', 18),
(22, 105, '2022-01-28', 22),
(6, 106, '2022-01-06', 20),
(23, 106, '2022-01-19', 25),
(7, 107, '2022-01-07', 25),
(8, 108, '2022-01-08', 30),
(24, 108, '2022-01-21', 35),
(9, 109, '2022-01-09', 35),
(25, 109, '2022-01-23', 40),
(26, 109, '2022-01-29', 45),
(10, 110, '2022-01-10', 40),
(11, 111, '2022-01-11', 45),
(27, 111, '2022-01-24', 50),
(12, 112, '2022-01-12', 50),
(13, 113, '2022-01-13', 55),
(28, 113, '2022-01-26', 60),
(14, 114, '2022-01-14', 60),
(15, 115, '2022-01-15', 65),
(29, 115, '2022-01-27', 70),
(30, 115, '2022-01-30', 75);

CREATE TABLE returns (
    return_id INT,
    order_id INT,
    return_date DATE,
    returned_items INT
);

INSERT INTO returns VALUES
(1, 1, '2022-01-03', 2),
(15, 16, '2022-01-18', 3),
(16, 17, '2022-01-22', 5),
(2, 2, '2022-01-05', 3),
(17, 18, '2022-01-20', 7),
(18, 19, '2022-01-27', 10),
(3, 3, '2022-01-07', 1),
(4, 5, '2022-01-08', 4),
(19, 21, '2022-01-24', 8),
(20, 22, '2022-01-30', 12),
(5, 6, '2022-01-08', 6),
(21, 23, '2022-01-21', 10),
(6, 7, '2022-01-09', 7),
(7, 8, '2022-01-10', 8),
(8, 9, '2022-01-11', 9),
(22, 25, '2022-01-25', 15),
(23, 26, '2022-01-31', 20),
(9, 10, '2022-01-12', 10),
(10, 11, '2022-01-13', 11),
(24, 27, '2022-01-26', 18),
(11, 12, '2022-01-14', 12),
(12, 13, '2022-01-15', 13),
(25, 28, '2022-01-28', 22),
(13, 14, '2022-01-16', 14),
(14, 15, '2022-01-17', 15),
(26, 29, '2022-01-29', 25),
(27, 30, '2022-02-01', 30);


-- --------------------
-- My Solution
-- --------------------
-- customer_id,
-- total_items_ordered by each cx
-- total_items_returned by each cx
-- 2/4*100 50% total_items_returned/total_items_ordered*100
SELECT * FROM orders;
SELECT * FROM returns;

-- Approach 1 (Using CTE)
WITH orders_cte AS (
SELECT
	customer_id,
	SUM(total_items_ordered) as total_items_ordered
FROM orders
GROUP BY customer_id
),

return_cte As (
SELECT
	o.customer_id,
	SUM(r.returned_items) as total_items_returned
FROM returns as r
JOIN orders as o
ON r.order_id = o.order_id
GROUP BY o.customer_id
)

SELECT
	oc.customer_id,
	oc.total_items_ordered,
	rc.total_items_returned,
	ROUND(CASE
		WHEN oc.total_items_ordered > 0 THEN (rc.total_items_returned::float/oc.total_items_ordered::float)*100
	ELSE 0 END::numeric, 2) as return_percentage
FROM orders_cte as oc
JOIN return_cte rc
ON oc.customer_id = rc.customer_id
ORDER BY return_percentage DESC 
LIMIT 5;

-- Approach 2 (When orders and returns are having 1 customer data)
select
o.*,
r.return_date,
r.returned_items,
round((r.returned_items*1.0/o.total_items_ordered)*100,2) as returned_item_perc
from orders as o
join returns as r
on o.order_id = r.order_id;
