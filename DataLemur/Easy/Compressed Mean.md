## Compressed Mean

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · ROUND · CAST |
| **Companies** | Alibaba |
| **Link** | https://datalemur.com/questions/alibaba-compressed-mean |

---

#### Problem Statement

Given a table where each row stores a number of items per order (`item_count`) and how many orders had that many items (`order_occurrences`), write a query to find the **mean** number of items per order, rounded to **1 decimal place**.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS items_per_order;

CREATE TABLE items_per_order (
    item_count        INTEGER,
    order_occurrences INTEGER
);

INSERT INTO items_per_order (item_count, order_occurrences) VALUES
(1, 500),
(2, 1000),
(3, 800),
(4, 1000);
-- weighted mean = (1*500 + 2*1000 + 3*800 + 4*1000) / (500+1000+800+1000)
--              = (500 + 2000 + 2400 + 4000) / 3300 = 8900 / 3300 ≈ 2.7
```

---

#### Solution

```sql
SELECT ROUND(CAST(SUM(item_count * order_occurrences) / SUM(order_occurrences) AS NUMERIC), 1) AS mean
FROM items_per_order;
```

---

#### Sample Output

| mean |
|------|
| 2.7  |
