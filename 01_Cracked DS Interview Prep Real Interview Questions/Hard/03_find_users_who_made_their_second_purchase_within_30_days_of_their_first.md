## Find users who made their second purchase within 30 days of their first.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | HARD |
| **Tags** | SELF JOIN, RETENTION |
| **Companies** | Netflix, Spotify |

---

#### Problem Statement

Identify users who made their second purchase within 30 days of their first purchase.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL(10,2) |
| product_id | INT |

---

#### Solution 1


```sql
--- Using SQLLite
-- Users with 2nd purchase within 30 days 
with ranked_orders as (SELECT
*,
rank() over(partition by user_id order by order_date) as rnk,
lag(order_date) over(partition by user_id order by order_date) as prev_purch
from orders
)
select
*
from ranked_orders
where rnk = 2
AND julianday(order_date) - julianday(prev_purch) <= 30
```

```sql
--- Using PostgresSQL
-- Users with 2nd purchase within 30 days 
with ranked_orders as (SELECT
*,
dense_rank() over(partition by user_id order by order_date) as rnk,
lag(order_date) over(partition by user_id order by order_date) as prev_purch
from orders
)
select
*
from ranked_orders
where rnk = 2
AND (order_date) - (prev_purch) <= 30
```


#### Solution 2

Using Self-Join

```sql
-- Users with 2nd purchase within 30 days
WITH ordered AS (
SELECT
user_id, order_date,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY order_date) AS rn
FROM orders
)
select
o1. user_id,
o1.order_date
from ordered as o1
join ordered as o2
on o1.user_id = o2.user_id
and o1.order_date < o2.order_date
where julianday(o1.order_date) - julianday(o2.order_date) <= 30
and o1.rn = 1 AND o2.rn = 2
```

---

#### Explanation

This query identifies users who made their second purchase within 30 days of their first purchase.

1.  **`ranked_orders` CTE**: This CTE calculates two window functions:
    -   `rank()`: Assigns a rank to each order for a given user, based on `order_date` in ascending order. The first purchase will have `rnk = 1`, the second `rnk = 2`, and so on.
    -   `lag(order_date)`: Retrieves the `order_date` of the previous order for the same user. This is crucial for comparing the current order's date with the preceding one.
2.  **Final SELECT**: The outer query selects all columns from `ranked_orders` and applies two filters:
    -   `rnk = 2`: This ensures we are only considering the second purchase of each user.
    -   `julianday(order_date) - julianday(prev_purch) <= 30`: This calculates the difference in days between the second purchase date (`order_date`) and the first purchase date (`prev_purch`). If the difference is 30 days or less, the user is included in the result.

---

#### Sample Output

| order_id | user_id | order_date | amount | product_id | rnk | prev_purch |
|----------|---------|------------|--------|------------|-----|------------|
| 2        | 1       | 2024-02-10 | 29.99  | 102        | 2   | 2024-01-15 |
| 9        | 5       | 2024-03-20 | 29.99  | 104        | 2   | 2024-03-01 |
