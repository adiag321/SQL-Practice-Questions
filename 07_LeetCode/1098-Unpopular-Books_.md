# 1098. Unpopular Books

## Problem Description

Write a solution to report the books that have sold less than 10 copies in the last year, excluding books that have been available for less than one month from today. Assume today is **2019-06-23**.

Return the result table in any order.

Link: https://leetcode.com/problems/unpopular-books/

## Table Schema

### Books Table

| Column Name    | Type    |
|----------------|---------|
| book_id        | int     |
| name           | varchar |
| available_from | date    |

- `book_id` is the primary key (column with unique values) of this table.

### Orders Table

| Column Name   | Type |
|---------------|------|
| order_id      | int  |
| book_id       | int  |
| quantity      | int  |
| dispatch_date | date |

- `order_id` is the primary key (column with unique values) of this table.
- `book_id` is a foreign key (reference column) to the `Books` table.

## Schema Setup

```sql
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    name VARCHAR(100),
    available_from DATE
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    book_id INT,
    quantity INT,
    dispatch_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

INSERT INTO Books (book_id, name, available_from)
VALUES
    (1, 'Kalila And Demna', '2010-01-01'),
    (2, '28 Letters', '2012-05-12'),
    (3, 'The Hobbit', '2019-06-10'),
    (4, '13 Reasons Why', '2019-06-01'),
    (5, 'The Hunger Games', '2008-09-21');

INSERT INTO Orders (order_id, book_id, quantity, dispatch_date)
VALUES
    (1, 1, 2, '2018-07-26'),
    (2, 1, 1, '2018-11-05'),
    (3, 3, 8, '2019-06-11'),
    (4, 4, 6, '2019-06-05'),
    (5, 4, 5, '2019-06-20'),
    (6, 5, 9, '2009-02-02'),
    (7, 5, 8, '2010-04-13');
```

## Example

### Input

**Books Table:**

| book_id | name               | available_from |
|---------|--------------------|----------------|
| 1       | Kalila And Demna   | 2010-01-01     |
| 2       | 28 Letters         | 2012-05-12     |
| 3       | The Hobbit         | 2019-06-10     |
| 4       | 13 Reasons Why     | 2019-06-01     |
| 5       | The Hunger Games   | 2008-09-21     |

**Orders Table:**

| order_id | book_id | quantity | dispatch_date |
|----------|---------|----------|---------------|
| 1        | 1       | 2        | 2018-07-26    |
| 2        | 1       | 1        | 2018-11-05    |
| 3        | 3       | 8        | 2019-06-11    |
| 4        | 4       | 6        | 2019-06-05    |
| 5        | 4       | 5        | 2019-06-20    |
| 6        | 5       | 9        | 2009-02-02    |
| 7        | 5       | 8        | 2010-04-13    |

### Output

| book_id | name             |
|---------|------------------|
| 1       | Kalila And Demna |
| 2       | 28 Letters       |
| 5       | The Hunger Games |

### Explanation

- Book 1 ("Kalila And Demna") sold only 3 copies in the last year (2 + 1, but order 1 is from 2018-07-26 which is more than a year ago, so only 0 copies in the last year). Available since 2010, so it qualifies.
- Book 2 ("28 Letters") had no orders at all. Available since 2012, so it qualifies.
- Book 3 ("The Hobbit") was available from 2019-06-10, which is less than one month from today (2019-06-23). Excluded.
- Book 4 ("13 Reasons Why") was available from 2019-06-01, which is less than one month from today. Excluded.
- Book 5 ("The Hunger Games") sold 0 copies in the last year. Available since 2008, so it qualifies.

## Solution

```sql
SELECT
    b.book_id,
    b.name
FROM Books b
LEFT JOIN Orders o
    ON b.book_id = o.book_id
    AND o.dispatch_date BETWEEN '2018-06-23' AND '2019-06-23'
WHERE b.available_from <= '2019-05-23'
GROUP BY b.book_id, b.name
HAVING COALESCE(SUM(o.quantity), 0) < 10;
```

## Approach

This problem requires filtering on two conditions:
1. **Exclude recently available books**: Filter out books available for less than one month (`available_from <= '2019-05-23'`).
2. **Find books with < 10 copies sold in the last year**: Use a `LEFT JOIN` with Orders filtered to the last year (`dispatch_date BETWEEN '2018-06-23' AND '2019-06-23'`), then group and check `SUM(quantity) < 10`.

**Key points:**
- Use `LEFT JOIN` (not `INNER JOIN`) so books with zero orders are included.
- Filter the date range in the `JOIN` condition, not in `WHERE`, to preserve books with no qualifying orders.
- Use `COALESCE(SUM(o.quantity), 0)` to handle NULL sums from the LEFT JOIN.

## Complexity

- **Time Complexity**: O(n + m) where n is the number of books and m is the number of orders
- **Space Complexity**: O(n) for storing the results