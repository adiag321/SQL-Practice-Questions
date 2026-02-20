-- 29/30 Days SQL Challenge
/*
-- Walmart Data Analyst Interview Question

Write a solution to select the product id, year, quantity, and price for the first year of every product sold.
*/

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT,
    product_id INT,
    year INT,
    quantity INT,
    price INT
);

INSERT INTO Sales (sale_id, product_id, year, quantity, price) 
VALUES
(7, 200, 2011, 15, 9000),
(15, 400, 2010, 18, 6200),
(2, 100, 2009, 12, 5000),
(19, 500, 2014, 28, 5500),
(8, 300, 2012, 25, 7500),
(1, 100, 2008, 10, 5000),
(11, 400, 2007, 14, 6500),
(5, 200, 2013, 20, 8500),
(16, 400, 2012, 22, 6000),
(3, 100, 2010, 8, 5500),
(20, 500, 2015, 35, 5300),
(12, 400, 2009, 16, 6400),
(9, 300, 2009, 30, 7200),
(17, 500, 2011, 24, 5800),
(6, 200, 2006, 18, 9200),
(13, 400, 2011, 20, 6100),
(4, 100, 2011, 15, 4800),
(21, 500, 2016, 40, 5100),
(10, 300, 2013, 22, 6800),
(14, 400, 2013, 19, 5900),
(18, 500, 2013, 26, 5600),
(22, 500, 2017, 45, 4900);


-- --------------------------
-- My Solutions 
-- --------------------------
-- first year product sale details 
-- product_id, year (MIN), qty and price
-- rank

SELECT 
	temp.product_id,
	temp.first_year,
	temp.quantity,
	temp.price
FROM (
	SELECT 
		product_id,
		year as first_year,
		quantity,
		price,
		RANK() OVER(PARTITION BY product_id ORDER BY year) as rn
	FROM sales
) as temp
WHERE rn = 1;