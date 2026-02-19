-- 24/30 SQL Challenge
/*
Question: Consider a table named customers with the following columns: 
customer_id, first_name, last_name, and email. 
Write an SQL query to find all the duplicate email addresses in the customers table.
*/

-- Creating the customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

-- Inserting sample data into the customers table
INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com'),
(4, 'Bob', 'Brown', 'bob.brown@example.com'),
(5, 'Emily', 'Davis', 'john.doe@example.com'),
(6, 'Michael', 'Williams', 'michael.w@example.com'),
(7, 'David', 'Wilson', 'jane.smith@example.com'),
(8, 'Sarah', 'Taylor', 'sarah.t@example.com'),
(9, 'James', 'Anderson', 'james.a@example.com'),
(10, 'Laura', 'Martinez', 'laura.m@example.com'),
(11, 'Robert', 'Garcia', 'bob.brown@example.com'),
(12, 'Jennifer', 'Lee', 'jennifer.lee@example.com'),
(13, 'Christopher', 'Moore', 'alice.johnson@example.com'),
(14, 'Amanda', 'Rodriguez', 'amanda.r@example.com'),
(15, 'Matthew', 'Clark', 'matthew.c@example.com'),
(16, 'Jessica', 'Lopez', 'michael.w@example.com'),
(17, 'Daniel', 'Hill', 'daniel.h@example.com'),
(18, 'Ashley', 'Scott', 'john.doe@example.com'),
(19, 'Joshua', 'Green', 'joshua.g@example.com'),
(20, 'Stephanie', 'Adams', 'jane.smith@example.com'),
(21, 'Andrew', 'Baker', 'andrew.b@example.com'),
(22, 'Michelle', 'Nelson', 'sarah.t@example.com'),
(23, 'Kevin', 'Carter', 'kevin.c@example.com'),
(24, 'Kimberly', 'Mitchell', 'alice.johnson@example.com'),
(25, 'Ryan', 'Perez', 'ryan.p@example.com');

-- -----------------------
-- My Solution
-- -----------------------
-- email
-- GROUP BY email 
-- HAVING COUNT(email ) > 1

SELECT
	email
	-- COUNT(email) as cnt_frequency
FROM customers
GROUP BY email
HAVING COUNT(email) > 1;
