E-commerce: Total Orders by Category
Medium

Question

Solution

Community9
Amazon is a large e-commerce platform where customers can order various items ranging from electronics to clothing.

You're provided with two tables, orders and items, with the following columns:

order_id	customer_id	order_date	item_id	order_quantity
integer	integer	date	integer	integer
item_id	item_category
integer	string
Write an SQL query to find how many units were ordered in each category in the last 7 days, for each day of the week. Sort alphabetically by item_category.

Desired output example:

item_category	order_date	total_units_ordered
Books	2023-09-26	4
Books	2023-09-28	5
Clothing	2023-09-27	7
Clothing	2023-09-30	3
Electronics	2023-09-25	2

# Solution
--  postgresql
select
i.item_category,
TO_CHAR(o.order_date, 'YYYY-MM-DD') as order_date,
SUM(o.order_quantity) as total_units_ordered
from items as i
left join orders as o
on i.item_id = o.item_id
wHERE o.order_date BETWEEN CURRENT_DATE - INTERVAL '6 days' AND CURRENT_DATE
GROUP BY i.item_category, o.order_date
order by 1,2;

