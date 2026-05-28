## Running total per user.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Running Total |
| **Companies** | Any |

---

#### Problem Statement

Calculate the running total of order amounts for each user, ordered by order date.

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

```sql
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
-- Running total per user
select
user_id,
order_date,
amount,
sum(amount) over(partition by user_id order by order_date asc) as running_total
from orders
order by 1,2,3;
```

---

#### Sample Output

| user_id | order_date | amount | running_total |
|---------|------------|--------|---------------|
| 1       | 2024-01-15 | 49.99  | 49.99         |
| 1       | 2024-02-10 | 29.99  | 79.98         |
| 1       | 2024-03-15 | 39.99  | 119.97        |
| 2       | 2024-01-20 | 19.99  | 19.99         |
| 3       | 2024-01-25 | 99.99  | 99.99         |
| 3       | 2024-02-25 | 49.99  | 149.98        |
