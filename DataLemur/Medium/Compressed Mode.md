## Compressed Mode

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Aggregation · Window Functions |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/compressed-mode |

---

#### Problem Statement

Given a table `items_per_order(item_count, order_occurrences)`, return the **mode** of `item_count` (i.e., the `item_count` that appears most frequently). The mode is calculated by finding the `order_occurrences` value that occurs most often and then selecting the corresponding `item_count`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS items_per_order;

CREATE TABLE items_per_order (
    item_count        INTEGER,
    order_occurrences INTEGER
);

INSERT INTO items_per_order (item_count, order_occurrences) VALUES
(1, 5),
(2, 3),
(3, 5),   -- item_count 1 and 3 both have order_occurrences 5 (most frequent)
(4, 2),
(5, 1);
```

---

#### Solution

```sql
SELECT item_count AS mode
FROM items_per_order
WHERE order_occurrences = (
    SELECT MODE() WITHIN GROUP (ORDER BY order_occurrences DESC)
    FROM items_per_order
)
ORDER BY mode;
```

---

#### Sample Output

| mode |
|------|
| 1 |
| 3 |
