## Most Recent Three Orders per customer.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · RANK · Top-N per Group |
| **Companies** | LeetCode |

---

#### Problem Statement

For each customer, find their 3 most recent orders. Return the customer name, customer ID, order ID, and order date, ordered by customer name, then customer ID, then most recent order first.

---

#### Create and Insert Statements

```sql
CREATE TABLE Customers_31 (
    customer_id INT PRIMARY KEY,
    name        TEXT
);

CREATE TABLE Orders_31 (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    order_date  DATE
);

INSERT INTO Customers_31 (customer_id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');

INSERT INTO Orders_31 (order_id, customer_id, order_date) VALUES
(1,  1, '2020-03-01'),
(2,  1, '2020-04-15'),
(3,  1, '2020-05-20'),
(4,  1, '2020-06-15'),
(5,  1, '2020-07-10'),
(6,  1, '2020-07-31'),
(7,  2, '2020-01-10'),
(8,  2, '2020-03-25'),
(9,  2, '2020-05-05'),
(10, 3, '2020-02-14'),
(11, 3, '2020-06-30'),
(12, 4, '2020-04-01'),
(13, 4, '2020-05-15'),
(14, 4, '2020-08-01'),
(15, 4, '2020-08-01');
```

---

#### Solution

```sql
with cte1 as (select
c.name,
o.customer_id,
o.order_id,              
o.order_date,
rank() over(partition by customer_id order by order_date desc) as rnk
from Customers_31 as c
left join Orders_31 as o
on c.customer_id = o.customer_id
              )
select
name,
customer_id,
order_id,              
order_date
from cte1
where rnk <=3;
```

---

#### Explanation

This is the classic **Top-N per Group** pattern — one of the most common SQL interview patterns.

- `RANK()` assigns a rank within each customer partition, ordered by `order_date DESC` (most recent = rank 1).
- `WHERE ranking <= 3` keeps only the top 3 most recent orders per customer.
- **RANK vs ROW_NUMBER:** `RANK` gives the same rank to ties (e.g., two orders on the same date both get rank 1). Use `ROW_NUMBER` if you want exactly 3 rows even with ties.
- Final `ORDER BY` groups results by customer name, then shows most recent orders first.

---

#### Sample Output

| customer_name | customer_id | order_id | order_date |
|---------------|-------------|----------|------------|
| Alice         | 1           | 6        | 2020-07-31 |
| Alice         | 1           | 5        | 2020-07-10 |
| Alice         | 1           | 4        | 2020-06-15 |

---