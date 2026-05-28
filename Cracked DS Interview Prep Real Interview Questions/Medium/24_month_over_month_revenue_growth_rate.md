## Month-over-month revenue growth rate.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions, Revenue |
| **Companies** | Amazon |

---

#### Problem Statement

Calculate the month-over-month revenue growth rate based on the orders data.

---

#### Tables Used

**`users`**

| Column | Type |
|--------|------|
| user_id | INT |
| signup_date | DATE |
| country | TEXT |
| plan | TEXT |

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL(10,2) |

```sql
CREATE TABLE users (
    user_id     INT PRIMARY KEY,
    signup_date DATE,
    country     TEXT,
    plan        TEXT
);

CREATE TABLE orders (
    order_id   INT PRIMARY KEY,
    user_id    INT,
    order_date DATE,
    amount     DECIMAL(10,2)
);
```

---

#### Solution

```sql
with mnth_data as (SELECT
strftime('%m', order_date) as month,
sum(amount) as total_amt
from orders
group by 1
)
select
*,
lag(total_amt) over(order by month asc) as next_mnth,
round((lag(total_amt) over(order by month asc) - total_amt)*100.00/lag(total_amt) over(order by month asc), 2) as growth_pct
from mnth_data
```

---

#### Explanation

This query calculates the month-over-month revenue growth rate.

- `strftime('%Y-%m', order_date)` extracts the year and month from the `order_date` to group by month.
- `SUM(amount)` calculates the total revenue for each month.
- `LAG(SUM(amount)) OVER(ORDER BY strftime('%Y-%m', order_date))` retrieves the revenue from the previous month. This is a window function that looks back one row based on the monthly order.
- The `growth_pct` is calculated as `(current_month_revenue - previous_month_revenue) / previous_month_revenue * 100`. The `ROUND` function formats the percentage to two decimal places.
- The results are grouped by month and ordered chronologically.

---

#### Sample Output

| month    | revenue | prev_revenue | growth_pct |
|----------|---------|--------------|------------|
| 2024-01  | 169.97  | NULL         | NULL       |
| 2024-02  | 114.97  | 169.97       | -32.36     |
| 2024-03  | 344.94  | 114.97       | 200.03     |
