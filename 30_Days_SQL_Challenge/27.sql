-- 27/30 
/*
-- Flipkart Data Analyst Interview Questions
-- Question: Write an SQL query to fetch user IDs that have only bought both 'Burger' and 'Cold Drink' items.

-- Expected Output Columns: user_id
*/

CREATE TABLE orders (
    user_id INT,
    item_ordered VARCHAR(512)
);

INSERT INTO orders VALUES 
('1', 'Pizza'),
('1', 'Burger'),
('2', 'Cold Drink'),
('2', 'Burger'),
('3', 'Burger'),
('3', 'Cold Drink'),
('4', 'Pizza'),
('4', 'Cold Drink'),
('5', 'Cold Drink'),
('6', 'Burger'),
('6', 'Cold Drink'),
('7', 'Pizza'),
('8', 'Burger');

-- -----------------------
-- My Solution
-- -----------------------
-- user_id
-- COUNT(orders) = 2
-- DISTINCT 

-- Approach 1
select distinct o1.user_id,
--o1.item_ordered,
--o2.item_ordered,
--case when o1.item_ordered in ('Burger','Cold Drink') 
--	and o2.item_ordered in ('Burger','Cold Drink') then 1 else 0 end as cold_drink_burger
from orders as o1
join orders as o2
	on o1.user_id = o2.user_id
	and o1.item_ordered <> o2.item_ordered
where o1.user_id in (
	select user_id
	from orders
	group by user_id
	having count(user_id) = 2
	)
and (case when o1.item_ordered in ('Burger','Cold Drink') 
	and o2.item_ordered in ('Burger','Cold Drink') then 1 else 0 end) = 1


-- Approach 2
SELECT 
	user_id
	-- COUNT(DISTINCT item_ordered)
FROM orders
GROUP BY user_id
HAVING COUNT(DISTINCT item_ordered) = 2
AND
	SUM(CASE WHEN item_ordered IN ('Burger', 'Cold Drink') 
		THEN 1
		ELSE 0
	END
	) = 2

