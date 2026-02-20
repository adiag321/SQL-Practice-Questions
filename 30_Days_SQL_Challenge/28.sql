-- 28/30 Days SQL Challenge!
/*
-- Amazon DS Interview Question
-- Given two tables, orders and return, containing sales and returns data for Amazon's 
	write a SQL query to find the top 3 sellers with the highest sales amount but the lowest lowest return qty. 
*/

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    seller_id INT,
    sale_amount DECIMAL(10, 2)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    seller_id INT,
    return_quantity INT
);

INSERT INTO orders (order_id, seller_id, sale_amount) VALUES
(1, 101, 1500.00),
(2, 102, 2200.00),
(3, 103, 1800.00),
(4, 104, 2500.00),
(5, 107, 1900.00),
(6, 106, 2100.00),
(7, 107, 2400.00),
(8, 107, 1700.00),
(9, 108, 2000.00),
(10, 107, 2300.00),
(11, 103, 2600.00),
(12, 102, 2900.00),
(13, 101, 3100.00),
(14, 101, 2800.00),
(15, 101, 3300.00),
(16, 106, 2700.00),
(17, 101, 3000.00),
(18, 108, 3200.00),
(19, 107, 3400.00),
(20, 106, 3500.00),
(21, 101, 3600.00),
(22, 102, 3700.00),
(23, 103, 3800.00),
(24, 102, 3900.00),
(25, 105, 4000.00),
(26, 104, 1650.00),
(27, 106, 4100.00),
(28, 108, 2750.00),
(29, 103, 3350.00),
(30, 105, 2450.00),
(31, 107, 4200.00),
(32, 101, 3950.00),
(33, 102, 4300.00),
(34, 104, 2850.00),
(35, 108, 4500.00);

INSERT INTO returns (return_id, seller_id, return_quantity) VALUES
(1, 101, 10),
(2, 102, 5),
(3, 103, 8),
(4, 104, 3),
(5, 105, 12),
(6, 106, 6),
(7, 107, 4),
(8, 108, 9),
(9, 101, 7),
(10, 103, 5),
(11, 106, 4),
(12, 108, 11);


-- ------------------
-- My Solution
-- ------------------
-- total_sales by each seller
-- total_qty return by each seller

SELECT * FROM orders;
SELECT * FROM returns;

-- Approach 1: Using Left join
WITH orders_cte AS (
	SELECT
		seller_id,
		SUM(sale_amount) as total_sales
	FROM orders
	GROUP BY seller_id	
),

returns_cte AS (
	SELECT
		seller_id,
		SUM(return_quantity) as total_return_qty
	FROM returns
	GROUP BY seller_id
)

SELECT 
	orders_cte.seller_id as seller_id,
	orders_cte.total_sales as total_sale_amt,
	COALESCE(returns_cte.total_return_qty, 0) as total_return_qty
FROM orders_cte
LEFT JOIN returns_cte
	ON orders_cte.seller_id = returns_cte.seller_id
ORDER BY total_sale_amt DESC, total_return_qty ASC
LIMIT 3;

-- Approach 2: Using Inner join
with total_sales as (
	select
		o.seller_id,
		sum(sale_amount) as total_sales
	from orders as o
	group by 1
),

total_returns as (
	select
		r.seller_id,
		sum(return_quantity) as total_return_qty
	from  returns as r
	group by 1
)

select
	s.seller_id,
	s.total_sales,
	r.total_return_qty
from total_sales as s
inner join total_returns as r
	on s.seller_id = r.seller_id
order by total_sales desc, total_return_qty asc
limit 3;
