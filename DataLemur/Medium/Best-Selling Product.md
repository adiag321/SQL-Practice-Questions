## Best-Selling Product

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | SQL · Window Functions |
| **Companies** | Wayfair |

---

#### Problem Statement

For each product category, identify the best-selling product based on highest `sales_quantity`. If there is a tie in quantity, choose the product with the higher `rating`. Return the category and product names.

Question Link: <https://datalemur.com/questions/best-selling-products>

---

#### Table Used

**`products`**

| Column | Type |
|--------|------|
| `product_id` | integer |
| `product_name` | varchar |
| `category_name` | varchar |
| `rating` | numeric |

**`product_sales`**

| Column | Type |
|--------|------|
| `product_id` | integer |
| `sales_quantity` | integer |

---

#### Solution

```sql
with total_sales_by_prod as (SELECT
  p.category_name,
  p.product_id,
  p.product_name,
  ps.rating,
  sum(ps.sales_quantity) as total_sales
  FROM products as p
  join product_sales as ps
  on p.product_id = ps.product_id
  group by 1,2,3,4
  order by 1
),
sales_ranking as (SELECT
  *,
  dense_rank() over(partition by category_name order by total_sales desc, rating desc) as rnk
  from total_sales_by_prod
)
SELECT
category_name,
product_name
from sales_ranking
where rnk = 1
```

---

#### Sample Output

| category_name | product_name |
|---------------|--------------|
| Books | The Great Gatsby |
| Clothing | Designer Jeans |
| Electronics | Curved Monitor |
