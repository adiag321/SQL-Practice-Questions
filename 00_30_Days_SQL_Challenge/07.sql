-- Day 07/30 SQL Challenge
/*
-- Amazon Interview question

Question:
Write a query to identify the top two highest-grossing products within each category in the year 2022. 
Output should include the category, product, and total spend.

Question link: https://datalemur.com/questions/sql-highest-grossing
*/

-- Create product_spend table
CREATE TABLE product_spend (
    category VARCHAR(255),
    product VARCHAR(255),
    user_id INTEGER,
    spend DECIMAL(10, 2),
    transaction_date TIMESTAMP
);
INSERT INTO product_spend (category, product, user_id, spend, transaction_date) VALUES
('appliance', 'refrigerator', 165, 246.00, '2021-12-26 12:00:00'),
('appliance', 'refrigerator', 123, 299.99, '2022-03-02 12:00:00'),
('appliance', 'washing machine', 123, 219.80, '2022-03-02 12:00:00'),
('electronics', 'vacuum', 178, 152.00, '2022-04-05 12:00:00'),
('electronics', 'wireless headset', 156, 249.90, '2022-07-08 12:00:00'),
('electronics', 'vacuum', 145, 189.00, '2022-07-15 12:00:00'),
('furniture', 'sofa', 167, 499.99, '2022-09-10 12:00:00'),
('furniture', 'dining table', 178, 799.00, '2022-11-20 12:00:00'),
('furniture', 'sofa', 145, 450.00, '2022-12-25 12:00:00'),
('furniture', 'dining table', 156, 750.00, '2022-12-30 12:00:00'),
('appliance', 'refrigerator', 189, 320.00, '2022-12-31 12:00:00'),
('electronics', 'wireless headset', 190, 199.99, '2022-12-31 12:00:00'),
('appliance', 'washing machine', 200, 250.00, '2022-12-31 12:00:00'),
('furniture', 'sofa', 210, 550.00, '2022-12-31 12:00:00');

-- ----------------------------------------------
-- My solution
-- ----------------------------------------------

WITH TOTAL_TRANS AS (
  SELECT
  CATEGORY,
  PRODUCT,
  SUM(SPEND) AS TOTAL_SPEND
  FROM PRODUCT_SPEND
  WHERE EXTRACT(YEAR FROM TRANSACTION_DATE) = 2022
  GROUP BY 1,2
),
HIGH_SELL_PROD AS (
SELECT
  *,
  ROW_NUMBER() OVER(PARTITION BY CATEGORY ORDER BY TOTAL_SPEND DESC) AS RW_NM
  FROM TOTAL_TRANS
)
SELECT
CATEGORY, 
PRODUCT, 
TOTAL_SPEND
FROM HIGH_SELL_PROD
WHERE RW_NM <= 2;

