## Multiple orders same day.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Having |
| **Companies** | Any |

---

#### Problem Statement

Multiple orders same day.

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| order_id | INT (PK) |
| user_id | INT |
| order_date | DATE |
| amount | DECIMAL |
| product_id | INT |

---

#### Solution

```sql
-- Same-day multi-orders\nSELECT\n
SELECT
order_date,
count(distinct order_id) as multiple_orders
from orders
group by 1
order by 1;
```

---

#### Sample Output

| order_date | multiple_orders |
|------------|-----------------|
| 2024-01-15 | 1               |
| 2024-01-20 | 1               |
| 2024-01-25 | 1               |
| 2024-02-10 | 1               |
| 2024-02-25 | 1               |
| 2024-02-28 | 1               |
