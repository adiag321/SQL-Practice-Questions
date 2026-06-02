## Swapped Food Delivery

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | SQL · Window Functions |
| **Companies** | Zomato |

---

#### Problem Statement

Zomato has an `orders` table containing each `order_id` and the food `item` ordered. Due to a system glitch, items for adjacent orders were swapped. Write a query to swap items back in pairs (`1↔2`, `3↔4`, etc.). If the number of orders is odd, keep the last order item unchanged.

Question Link: <https://datalemur.com/questions/sql-swapped-food-delivery>

---

#### Table Used

**`orders`**

| Column | Type |
|--------|------|
| `order_id` | integer |
| `item` | varchar |

---

#### Solution

```sql
WITH cte AS (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY order_id) AS rw_nm
  FROM orders
)
SELECT
  rw_nm AS corrected_order_id,
  COALESCE(
    CASE
      WHEN rw_nm % 2 = 0 THEN LAG(item) OVER ()
      ELSE LEAD(item) OVER ()
    END,
    item
  ) AS item
FROM cte;
```

---

#### Sample Output

| corrected_order_id | item |
|--------------------|------|
| 1 | Pizza |
| 2 | Chow Mein |
| 3 | Butter Chicken |
| 4 | Pad Thai |
| 5 | Burger |
| 6 | Eggrolls |
| 7 | Sushi |
| 8 | Tandoori Chicken |
| 9 | Ramen |
| 10 | Tacos |
| 11 | Lasagna |
| 12 | Burrito |
| 13 | Steak |
| 14 | Salad |
| 15 | Spaghetti |
