### Amazon BIE SQL Question
-- Table 1:
CREATE TABLE order_product (
    order_id INT,
    product_id VARCHAR(255),
    quantity INT
);

INSERT INTO order_product (order_id, product_id, quantity) VALUES
(1, 'a', 2),
(1, 'b', 4),
(2, 'b', 2),
(3, 'c', 5),
(3, 'a', 3),
(4, 'd', 10);

-- Table 2
CREATE TABLE shipment_order (
    shipment_id INT,
    order_id INT,
    cost NUMERIC(28, 10)
);

INSERT INTO shipment_order (shipment_id, order_id, cost) VALUES
(1, 1, 1.22),
(2, 4, 3.55),
(3, 3, 5.91),
(4, 2, 2.44);

-- Questions -
Table Name: order_product
order_id: int
product_id: varchar
quantity: int
+----------+------------+-----------+
| order_id | product_id | quantity |
+----------+------------+-----------+
| 1 | a | 2 |
| 1 | b | 4 |
| 2 | b | 2 |
| 3 | c | 5 |
| 3 | a | 3 |
| 4 | d | 10 |
+----------+------------+-----------+
Table Name: shipment_order
shipment_id: int
order_id: int
cost:numeric(28,10)
+-------------+----------+------+
| shipment_id | order_id | cost |
+-------------+----------+------+
| 1 | 1 | 1.22 |
| 2 | 4 | 3.55 |
| 3 | 3 | 5.91 |
| 4 | 2 | 2.44 |
+-------------+----------+------+

/*
Write a query that returns a single row for each order_id with a column for the quantity of product 'a', one with the quantity of product 'b', and one with the quantity for all other products

select
order_id,
sum(case when product_id = 'a'  then quantity else 0 end) as product_a,
sum(case when product_id = 'b' then quantity else 0 end) as product_b,
sum(case when product_id not in ('a', 'b') then quantity else 0 end) as product_others
from order_product
group by 1

*/
/*
Write a SQL query that calculates the cost per unit to complete each order and limit the result of the query to only top two orders with highest cost per unit


select
o.order_id,
round(s.cost / sum(o.quantity),2) as cost_per_unit
from order_product as o
join shipment_order as s on o.order_id = s.order_id
group by o.order_id, s.cost
order by 2 desc
*/

/*
Write a SQL query that returns each order, product_id, quantity, and its percent contribution to the total order quantity
*/

SELECT
    op.order_id,
    op.product_id,
    op.quantity,
    (op.quantity / total.total_quantity) AS contribution_pct
FROM order_product op
JOIN (
    SELECT
        order_id,
        SUM(quantity) AS total_quantity
    FROM
        order_product
    GROUP BY
        order_id
) total ON op.order_id = total.order_id;
