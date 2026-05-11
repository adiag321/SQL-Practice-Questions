## Users with spending increasing every month.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | HARD |
| **Tags** | TRENDS, Window Functions |
| **Companies** | Stripe |

---

#### Problem Statement

Identify users who have shown a consistent increase in their total spending every month.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL(10,2) |

---

#### Solution

```sql
-- Users with monotonically increasing spend
WITH total_user_spent AS (
    SELECT
        user_id, strftime('%Y-%m', order_date) AS order_month, SUM(amount) AS total_spent
    FROM orders
    GROUP BY 1, 2
),
prev_spend AS (
    SELECT user_id, order_month, total_spent AS cur_mnth_spent,
           LAG(total_spent) OVER(PARTITION BY user_id ORDER BY order_month) AS prev_mnth_spent,
           CASE WHEN LAG(total_spent) OVER(PARTITION BY user_id ORDER BY order_month) IS NULL
                     AND total_spent > LAG(total_spent) OVER(PARTITION BY user_id ORDER BY order_month)
                THEN 1 else 0 END as incr_spend
    FROM total_user_spent
)
SELECT user_id
FROM prev_spend
group by 1
having count(user_id) = sum(incr_spend)
```

---

#### Explanation

This query identifies users whose total monthly spending has consistently increased month over month.

1.  **`total_user_spent` CTE**: This CTE calculates the total `amount` spent by each `user_id` for every `order_month` (extracted as 'YYYY-MM' using `strftime`).
2.  **`prev_spend` CTE**: This CTE builds on the `total_user_spent` by:
    -   Calculating `prev_mnth_spent` using `LAG(total_spent)` partitioned by `user_id` and ordered by `order_month`.
    -   Introducing `incr_spend`, a `CASE` statement that marks `1` if the current month's spending (`total_spent`) is greater than the previous month's spending (`LAG(total_spent)`) and the previous month's spending is not `NULL` (to handle the first month). Otherwise, it's `0`.
3.  **Final SELECT**: The outer query groups by `user_id` and uses a `HAVING` clause. It checks if `count(user_id)` (total number of months a user has spent) is equal to `sum(incr_spend)` (total number of months where spending increased). If they are equal, it means the user's spending has increased every consecutive month.

---

#### Sample Output

| user_id |
|---------|
|         |
