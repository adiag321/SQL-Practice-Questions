## Users with 2nd purchase within 30 days.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | HARD |
| **Tags** | SELF JOIN, RETENTION |
| **Companies** | Netflix |

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

#### Solution

##### SQLite Solution

```sql
-- Quick repeat purchasers
WITH ranked_orders AS (
    SELECT *,
           DENSE_RANK() OVER(PARTITION BY user_id ORDER BY order_date) AS rnk,
           LAG(order_date) OVER(PARTITION BY user_id ORDER BY order_date) AS prev_order
    FROM orders
)
SELECT
    *
FROM ranked_orders
WHERE rnk <= 2
  AND julianday(order_date) - julianday(prev_order) <= 30;
```

##### PostgreSQL Solution

```sql
-- Quick repeat purchasers (PostgreSQL)
WITH ranked_orders AS (
    SELECT *,
           DENSE_RANK() OVER(PARTITION BY user_id ORDER BY order_date) AS rnk,
           LAG(order_date) OVER(PARTITION BY user_id ORDER BY order_date) AS prev_order
    FROM orders
)
SELECT
    *
FROM ranked_orders
WHERE rnk <= 2
  AND order_date - prev_order <= 30;
```

##### Alternative Solution (Self-Join)

```sql
-- Users with 2nd purchase within 30 days using Self-Join
WITH ordered AS (
    SELECT
        user_id, order_date,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY order_date) AS rn
    FROM orders
)
SELECT
    o2.user_id,
    o2.order_date
FROM ordered AS o1
JOIN ordered AS o2
  ON o1.user_id = o2.user_id
 AND o1.order_date < o2.order_date
WHERE julianday(o2.order_date) - julianday(o1.order_date) <= 30
  AND o1.rn = 1 AND o2.rn = 2;
```

---

#### Explanation

This query identifies users who made their second purchase within 30 days of their first purchase.

1.  **`ranked_orders` CTE**:
    -   `DENSE_RANK()`: Assigns a rank to each order for a given user, based on `order_date` in ascending order. The first purchase has `rnk = 1`, the second `rnk = 2`, and so on.
    -   `LAG(order_date)`: Retrieves the `order_date` of the previous order for the same user, aliasing it as `prev_order`.
2.  **Outer Query Filters**:
    -   `rnk <= 2`: Filters to focus on the first two orders.
    -   `julianday(order_date) - julianday(prev_order) <= 30`: Subtracts the previous order date from the current order date. For the first order (`rnk = 1`), `prev_order` is `NULL`, so this evaluates to `NULL` (and is filtered out). For the second order (`rnk = 2`), it correctly evaluates whether the time between the first and second purchase is 30 days or less.

---

#### Sample Output

| order_id | user_id | order_date | amount | product_id | rnk | prev_order |
|----------|---------|------------|--------|------------|-----|------------|
| 2        | 1       | 2024-02-10 | 29.99  | 102        | 2   | 2024-01-15 |
| 9        | 5       | 2024-03-20 | 29.99  | 104        | 2   | 2024-03-01 |
