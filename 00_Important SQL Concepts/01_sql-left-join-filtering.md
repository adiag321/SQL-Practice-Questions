# Understanding SQL LEFT JOIN: ON Clause vs. WHERE Clause Filtering

When working with a `LEFT JOIN` in SQL, placing a filter on the right (joined) table in the `ON` clause behaves entirely differently than placing it in the `WHERE` clause. This document explains the core differences with concrete examples.

---

## 1. The Concept

The fundamental difference lies in **when** the filter is applied during query execution:

* **Case 1: Filter in the `ON` clause**
  * The condition is applied *during* the join process. 
  * It restricts which rows from the right table are matched to the left table.
  * Because it is a `LEFT JOIN`, **all rows from the left table are preserved**, even if they do not meet the criteria. Unmatched rows simply return `NULL` values for the right table's columns.

* **Case 2: Filter in the `WHERE` clause**
  * The condition is applied *after* the join process has completed.
  * When a row from the left table has no match in the right table, the right table's columns become `NULL`.
  * The `WHERE` clause then checks if those `NULL` values fall within the specified date range. Since `NULL` fails the range evaluation, **these rows are completely filtered out**.
  * This effectively turns your `LEFT JOIN` into an `INNER JOIN`.

---

## 2. Create and Insert Statements

```sql
CREATE TABLE items (
    item_id INT PRIMARY KEY,
    item_category VARCHAR(50)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    item_id INT,
    order_quantity INT,
    order_datetime TIMESTAMP
);

INSERT INTO items (item_id, item_category) VALUES (1, 'Electronics');
INSERT INTO items (item_id, item_category) VALUES (2, 'Books');
INSERT INTO items (item_id, item_category) VALUES (3, 'Clothing');
INSERT INTO items (item_id, item_category) VALUES (4, 'Home & Kitchen');
INSERT INTO items (item_id, item_category) VALUES (5, 'Beauty');
INSERT INTO items (item_id, item_category) VALUES (6, 'Sports');

INSERT INTO orders (order_id, item_id, order_quantity, order_datetime) VALUES (101, 1, 5, '2026-07-14 10:00:00');
INSERT INTO orders (order_id, item_id, order_quantity, order_datetime) VALUES (102, 2, 3, '2026-05-01 12:00:00');
INSERT INTO orders (order_id, item_id, order_quantity, order_datetime) VALUES (103, 1, 2, '2026-07-15 08:30:00');
INSERT INTO orders (order_id, item_id, order_quantity, order_datetime) VALUES (104, 4, 1, '2026-07-09 14:15:00');
INSERT INTO orders (order_id, item_id, order_quantity, order_datetime) VALUES (105, 5, 4, '2026-07-05 18:00:00');
INSERT INTO orders (order_id, item_id, order_quantity, order_datetime) VALUES (106, 4, 3, '2026-07-12 11:45:00');
```

## 3. Solution (Case 1): Filter in the ON Clause
This query retains all categories from the items table, ensuring that even inactive categories are listed with a total unit count of 0.

```sql
SELECT
    i.item_category,
    COALESCE(SUM(o.order_quantity), 0) AS total_units_ordered
FROM items i
LEFT JOIN orders o 
    ON i.item_id = o.item_id 
    AND CAST(o.order_datetime AS DATE) BETWEEN CURRENT_DATE - 6 AND CURRENT_DATE
GROUP BY i.item_category;
```

## Explanation:
* `Electronics` matched an order within the date range, returning 5.
* `Books` had an order, but because it didn't match the ON condition, the join resulted in NULL for its quantity. COALESCE turned that NULL into 0.
* `Clothing` had no orders, resulting in a NULL join, which COALESCE also turned into 0.
* **Result**: Every single category is accounted for.

## 4. Output (Case 1)

| item_category | total_units_ordered |
|---------------|---------------------|
| Electronics   | 5                   |
| Books         | 0                   |
| Clothing      | 0                   |

## 5. Solution (Case 2): Filter in the WHERE Clause

This query eliminates any rows that do not have an order matching the date criteria after the join has taken place.

```sql
SELECT
    i.item_category,
    COALESCE(SUM(o.order_quantity), 0) AS total_units_ordered
FROM items i
LEFT JOIN orders o 
    ON i.item_id = o.item_id 
WHERE CAST(o.order_datetime AS DATE) BETWEEN CURRENT_DATE - 6 AND CURRENT_DATE
GROUP BY i.item_category;
```

## Explanation

* Initially, the LEFT JOIN evaluates. It yields data for Electronics, and produces NULL for Books and Clothing's order details.
* Next, the WHERE clause filters the results: WHERE CAST(o.order_datetime AS DATE) BETWEEN ...
* For Books and Clothing, o.order_datetime is NULL. Since NULL is not within the date range, both categories are completely dropped from the dataset before the GROUP BY happens.

## 6. Output (Case 2)

| item_category | total_units_ordered |
|---------------|---------------------|
| Electronics   | 5                   |