# Categorize Sales

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | CASE Statements · Date Functions · Data Aggregation |
| **Companies** | Retail & E-commerce |

Link: [Interview Query - Categorize Sales](https://www.interviewquery.com/questions/categorize-sales)
---

## Problem Statement

An electronics retail company tracks its sales and wants to run a performance analysis by categorizing sales into different groups based on amount, region, and timing. 

The conditions for categorization are:
- **Standard Sales**: Any sales below 2,000 are considered standard, except if they occur in the **East** region or in the month of **July**.
- **Premium Sales**: Any sales that are $\ge$ 2,000, or any sales in the **East** region (regardless of amount), are considered premium, except during the month of **July**.
- **Promotional Sales**: All sales made in the promotional period of **July**, regardless of amount or region, are considered promotional.

The goal is to produce a report that sums these categories by region. *Note: You may assume the table contains data only for 2023.*

---

## Table Used

**`sales`**

| Column | Type |
|--------|------|
| sale_id | INTEGER |
| employee_id | INTEGER |
| product_id | INTEGER |
| sale_amount | FLOAT |
| sale_date | DATE |
| region | TEXT |

```sql
CREATE TABLE sales (
  sale_id INTEGER PRIMARY KEY,
  employee_id INTEGER,
  product_id INTEGER,
  sale_amount FLOAT,
  sale_date DATE,
  region TEXT
);

INSERT INTO sales (sale_id, employee_id, product_id, sale_amount, sale_date, region) VALUES
(1, 101, 1, 1500, '2023-01-10', 'North'),   -- Standard
(2, 102, 2, 2500, '2023-02-15', 'North'),   -- Premium (Amount)
(3, 103, 1, 500, '2023-03-20', 'East'),     -- Premium (Region)
(4, 104, 3, 3000, '2023-07-05', 'West'),    -- Promotional (July)
(5, 101, 2, 1200, '2023-07-20', 'East'),    -- Promotional (July)
(6, 105, 1, 1800, '2023-05-12', 'West');    -- Standard
(7, 106, 3, 2200, '2023-06-30', 'East');    -- Premium (Region)
(8, 107, 2, 800, '2023-07-15', 'North');    -- Promotional (July)
(9, 108, 1, 1700, '2023-08-01', 'North');   -- Standard
(10, 109, 3, 2100, '2023-09-10', 'West');   -- Premium (Amount)
```

## Solution
````sql
WITH categorized_tab AS (
  SELECT 
    region,
    sale_amount,
    -- Promotional Sales: July only
    CASE WHEN EXTRACT(MONTH FROM sale_date) = 7 
         THEN sale_amount ELSE 0 END AS promotional_sales,
    -- Premium Sales: >= 2000 or East region (but not in July)
    CASE WHEN (sale_amount >= 2000 OR region = 'East') 
              AND EXTRACT(MONTH FROM sale_date) <> 7
         THEN sale_amount ELSE 0 END AS premium_sales,
    -- Standard Sales: < 2000 and not East and not July
    CASE WHEN sale_amount < 2000 
              AND region <> 'East' 
              AND EXTRACT(MONTH FROM sale_date) <> 7
         THEN sale_amount ELSE 0 END AS standard_sales
  FROM sales
)
SELECT 
    region,
    SUM(sale_amount) AS total_sales,
    SUM(premium_sales) AS premium_sales,
    SUM(standard_sales) AS standard_sales,
    SUM(promotional_sales) AS promotional_sales
FROM categorized_tab
GROUP BY region
ORDER BY region;
````

## Sample Output

region | total_sales | premium_sales | standard_sales | promotional_sales
--------|-------------|---------------|----------------|------------------
East    | 1700.0      | 500.0         | 0.0            | 1200.0
North   | 4000.0      | 2500.0        | 1500.0         | 0.0
West    | 4800.0      | 2100.0        | 2700.0         | 0.0