/*When you login to your retailer clients database you notice that their product catalogue data is full of gaps in the category column. can you write a SQL query that returns the product catalogue with the missing data field in?

Assumptions:

Each categories mentioned only once in a category column.
All the products belonging to same category are grouped together.
The first product from a product group will always have a define category (meaning that the first item from each category will not have a missing category value).
products table:


MySQL code with DDL and DML commands:

CREATE TABLE products (
product_id INT PRIMARY KEY,
category VARCHAR(255),
name VARCHAR(255)
);

INSERT INTO products (product_id, category, name)
VALUES
(1, ‘Electronics’, ‘Laptop’),
(2, NULL, ‘Tablet’),
(3, NULL, ‘Smartphone’),
(4, ‘Clothing’, ‘T-Shirt’),
(5, NULL, ‘Jeans’),
(6, NULL, ‘Sneakers’);
*/

-- SOLUTION
WITH grouped_products AS
(
    SELECT
        product_id,
        category,
        name,
        COUNT(category) OVER (ORDER BY product_id) AS category_group
    FROM products
)

SELECT
    product_id,
    CASE
        WHEN category IS NULL THEN FIRST_VALUE(category) OVER (PARTITION BY category_group)
        ELSE category
    END AS category,
    name
FROM
    grouped_products