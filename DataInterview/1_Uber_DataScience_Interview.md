#### Q1)
select
extract(month from order_place_time) as month,
round(sum(late_orders)::decimal/count(late_orders)*100,2) as perc_late_orders
from 
(
select
*,
case when (actual_delivery_time - predictied_delivery_time) > 20 then 1 else 0 end as late_orders
from delivery_orders
)
group by 1

#### Q2) looking at the Uber Eats driver completing their first-ever order. what is the % of drivers first ever order and rating of 0
with driver_details as (select
driver_id,
delivery_rating,
row_number() over(partition by driver_id order by actual_delivery_time asc) as rw_nm
from delivery_order
),
first_order as (
select
*
from driver_details
where rw_nm = 1
)
select
round(sum(case when delivery_rating = 0 then 1 else 0 end)::decimal/count(distinct driver_id)*100,2) as perc_driver_with_0_rating
from first_order

#### Q3) in year 2021 grouped by month, what % of our uber eats restaurant base fulfilled more than 100$ in monthly sales?

select
extract(month from order_place_time),
round(sum(case when o.sales > 100 then 1 else 0 end)::decimal/count(distinct restaurant_id)*100,2) as perc_
from delivery_orders as d
join order_value as o on d.delivery_id = o.delivery_id
where extract(year from order_place_time) = 2021
group by 1



