## Unpopular Books: Books with fewer than 10 copies sold in the last year.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | NOT IN · DATE functions · HAVING |
| **Companies** | LeetCode |

---

#### Problem Statement

Find all books that have sold fewer than 10 copies in the last year (from today's date `2019-06-23`). Exclude books that have been available for less than 1 month.

---

#### Create and Insert Statements

```sql
CREATE TABLE Books (
    book_id        INT PRIMARY KEY,
    name           TEXT,
    available_from DATE
);

CREATE TABLE Orders_29 (
    order_id      INT PRIMARY KEY,
    book_id       INT,
    quantity      INT,
    dispatch_date DATE
);

INSERT INTO Books (book_id, name, available_from) VALUES
(1, 'Kalila And Demna',    '2010-01-01'),   
(2, 'The Pilot Masterbook', '2018-07-15'),  
(3, 'The Surveyor',        '2019-02-01'),   
(4, 'The Great Code',      '2019-06-01'),   
(5, 'Heart of SQL',        '2017-04-01'),   
(6, 'Brave New World',     '2015-01-01');   

INSERT INTO Orders_29 (order_id, book_id, quantity, dispatch_date) VALUES
(1, 2, 5,  '2018-10-01'),
(2, 2, 5,  '2019-04-15'),
(3, 3, 3,  '2019-03-01'),
(4, 3, 5,  '2019-05-10'),
(5, 4, 2,  '2019-06-15'),
(6, 5, 15, '2017-08-01'),
(7, 5, 5,  '2019-01-20'),
(8, 6, 7,  '2019-02-01'),
(9, 6, 3,  '2019-03-15');
```

---

#### Solution

-- Solution 1: Using CTE
```sql
with cte1 as (select
*
from Books
where available_from not between '2019-06-23' - interval 1 month and '2019-06-23'
)
select
c.book_id,
c.name,
sum(coalesce(quantity,0)) as total_sold
from cte1 as c
left join Orders_29 as o
on o.book_id = c.book_id
where o.dispatch_date between '2019-06-23' - interval 1 year and '2019-06-23'
or o.dispatch_date is NULL                                               -- Condition important to filter books not yet sold
group by 1,2
having sum(coalesce(quantity,0)) < 10
```

-- Solution 2
```sql
SELECT book_id, name
FROM Books
WHERE book_id NOT IN (
    SELECT book_id
    FROM Orders_29
    WHERE dispatch_date BETWEEN date('2019-06-23', '-1 year') AND '2019-06-23'
    GROUP BY book_id
    HAVING SUM(quantity) >= 10
)
AND available_from < date('2019-06-23', '-1 month')
```

---

#### Explanation

Three conditions must be met for a book to be included:

- **`NOT IN` subquery:** Excludes books that sold 10 or more copies in the last year. The subquery groups by `book_id` and uses `HAVING SUM(quantity) >= 10` to identify popular books.
- **Date window:** `dispatch_date BETWEEN` the date one year ago and today filters orders to the relevant period only.
- **`available_from` filter:** `available_from < date('2019-06-23', '-1 month')` ensures the book has been available for at least one month.

**Edge cases:**
- Books with **zero orders** are included (they won't appear in the subquery).
- `SUM(quantity)` is used instead of `COUNT(*)` because one order can have multiple copies.
- `date()` with modifiers handles month boundaries correctly in SQLite.

---

#### Sample Output

| book_id	| name	             | total_sold |
| ----------|--------------------|------------|
| 1	        | Kalila And Demna	 |   0        |
| 3	        | The Surveyor	     |   8        | 
| 5	        | Heart of SQL	     |   5        |