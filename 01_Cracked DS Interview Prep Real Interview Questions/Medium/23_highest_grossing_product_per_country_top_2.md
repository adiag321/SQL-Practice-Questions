## Highest-grossing product per country (top 2).

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions, TOP-N |
| **Companies** | Amazon, Meta |

---

#### Problem Statement

Identify the top 2 highest-grossing products for each country based on their total sales amount.

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
| product_id | INT |

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
    amount     DECIMAL(10,2),
    product_id INT
);
```

---

#### Solution

```sql
-- Top 2 products per country by revenue
with ranked as (SELECT
u.country,
o.product_id,
sum(amount) as total_amt,
rank() over(partition by u.country order by sum(amount) desc) as rnk
from orders as o
join users as u
on o.user_id = u.user_id
group by 1,2
)
select
*
from ranked
where rnk <=2
```

---

#### Explanation

This query determines the top 2 highest-grossing products within each country.

- A Common Table Expression (CTE) named `ranked` is used to calculate the total `amount` for each `product_id` within each `country`.
- `RANK()` is then applied as a window function, partitioning by `country` and ordering by the `total_amt` in descending order. This assigns a rank to each product within its country based on its revenue.
- The main query selects all columns from the `ranked` CTE where `rnk` is less than or equal to 2, effectively retrieving the top 2 products for each country.

---

#### Sample Output

| country | product_id | total_amt | rnk |
|---------|------------|-----------|-----|
| CA      | 101        | 104.98    | 1   |
| UK      | 101        | 19.99     | 1   |
| US      | 102        | 234.96    | 1   |
| US      | 103        | 139.98    | 2   |
