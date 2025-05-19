Amazon Orders SQL Technical Assessment
This question about Amazon orders comes from a real Amazon Data Analyst SQL assessment. It’s a multi-part SQL question, similar to how take-home SQL challenges are structured, and asks increasingly more complex questions about the amazon orders.

Amazon Orders Data
Your given an orders table:

ORDERS:

order_id (composite primary key)
customer_id (integer)
order_datetime (timestamp)
item_id (composite primary key)
order_quantity (integer)
Here’s some sample data from orders:

order_id	customer_id	order_datetime	      item_id	     order_quantity
O-001	        42489	        2023-06-15 04:35:22	C004		3
O-005		11733		2023-01-12 11:48:35	C005		1
O-005		11733		2023-01-12 11:48:35	C008		1
O-006		83167		2023-01-16 02:52:07	C012		2
You are also given an items table:

ITEMS:

item_id (pimary_key)
item_category (string)
Here’s some sample data from items:

item_id	item_category
C004	Books
C005	Books
C006	Apparel
C007	Electronics
C008	Electronics

Amazon SQL Assessment Questions:

1. How many units were ordered yesterday? Hint: Yesterday’s date be found via the PostgreSQL snippet SELECT current_date - INTEGER '1' AS yesterday_date
2. In the last 7 days (including today), how many units were ordered in each category? Hint: You need to consider ALL categories, even those with zero orders!
3. Write a query to get the earliest order_id for all customer for each date they placed an order. Hint: customers can place multiple orders on a single day!
4. Write a query to find the second earliest order_id for each customer for each date they placed two or more orders.
