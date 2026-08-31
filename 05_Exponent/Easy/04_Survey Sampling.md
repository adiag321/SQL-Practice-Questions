## Survey Sampling

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Companies** | Nielsen |

---

#### Problem Statement

Nielsen is a global measurement and data analytics company that provides the most complete and trusted view available of consumers and markets worldwide. Nielsen's databases contain information on hundreds of thousands of products, customers, and buying behaviors.

You're given a table called `customers` with the following columns:

- `customer_id` (integer): A unique identifier for each customer.
- `customer_name` (string): The name of the customer.
- `products_bought` (integer): The number of products bought by the customer in the last year.
- `last_survey_date` (date): The date the customer was last surveyed.

The company wants to regularly survey a subset of their customers to gather market insights, but they want to ensure a diverse set of opinions. Therefore, they've decided to select every 3rd customer based on their row index in the database.

Write an SQL query that returns the `customer_id` and `customer_name` of every 3rd customer based on their row index in the `customers` table.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(50),
    products_bought INTEGER,
    last_survey_date DATE
);

INSERT INTO customers (customer_id, customer_name, products_bought, last_survey_date) VALUES
(1, 'Alice', 5, '2024-01-10'),
(2, 'Bob', 3, '2024-01-11'),
(3, 'Charlie', 8, '2024-01-12'),
(4, 'Diana', 2, '2024-01-13'),
(5, 'Eve', 6, '2024-01-14'),
(6, 'Frank', 4, '2024-01-15'),
(7, 'Grace', 7, '2024-01-16'),
(8, 'Heidi', 1, '2024-01-17'),
(9, 'Ivan', 9, '2024-01-18');
```

---

#### Solution

```sql
-- postgresql

WITH cte AS (
    SELECT
        *,
        ROW_NUMBER() OVER () AS rw
    FROM customers
)
SELECT
    customer_id,
    customer_name
FROM cte
WHERE rw % 3 = 0;
```

---

#### Sample Output

| customer_id | customer_name |
|--------------|----------------|
| 3            | Charlie        |
| 6            | Frank          |
| 9            | Ivan           |
