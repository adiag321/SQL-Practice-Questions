## Walmart Inventory Status

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/practice/prepare/walmart-inventory-status |

---

#### Problem Statement

Walmart is one of the world's largest retail chains with a variety of products ranging from electronics to groceries. Shoppers come to Walmart to buy their desired items, and the company tracks its sales meticulously to understand market trends and customer preferences.

Write a SQL query that returns a table listing all products, and marks those products that haven't been sold yet.

The output should contain the following columns: `product_id`, `product_name`, `sale_status` in which `sale_status` can either be "Sold" or "Not Sold".

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50)
);

CREATE TABLE sales (
    sale_id INTEGER PRIMARY KEY,
    product_id INTEGER,
    quantity_sold INTEGER,
    sale_date DATE
);

INSERT INTO products (product_id, product_name, category) VALUES
(1, 'iPhone 14', 'Electronics'),
(2, 'Running Shoes', 'Apparel'),
(3, 'Organic Bananas', 'Groceries'),
(4, 'Wireless Headphones', 'Electronics');

INSERT INTO sales (sale_id, product_id, quantity_sold, sale_date) VALUES
(1, 1, 2, '2024-01-10'),
(2, 3, 5, '2024-01-11'),
(3, 1, 1, '2024-01-12');
```

---

#### Solution

```sql
SELECT DISTINCT
    p.product_id,
    p.product_name,
    CASE 
        WHEN s.product_id IS NOT NULL THEN 'Sold' 
        ELSE 'Not Sold' 
    END AS sale_status
FROM products AS p
LEFT JOIN sales AS s ON p.product_id = s.product_id
ORDER BY 1;
```

---

#### Sample Output

| product_id | product_name        | sale_status |
|------------|---------------------|-------------|
| 1          | iPhone 14           | Sold        |
| 2          | Running Shoes       | Not Sold    |
| 3          | Organic Bananas     | Sold        |
| 4          | Wireless Headphones | Not Sold    |
