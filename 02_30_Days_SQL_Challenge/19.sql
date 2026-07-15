-- --  Day 19/30 SQL Challenge
-- Google Interview Question for DA
-- Question: Get the count of distint student that are not unique 

CREATE TABLE student_names(
    student_id INT,
    name VARCHAR(50)
);
INSERT INTO student_names (student_id, name) VALUES
(1, 'RAM'),
(2, 'ROBERT'),
(3, 'ROHIM'),
(4, 'RAM'),
(5, 'ROBERT'),
(6, 'QWERTY');

------------------------------
-- My solution
------------------------------
SELECT 
	COUNT(*) as distint_student_cnt
FROM 
	(
	SELECT name,
		COUNT(name) 
	FROM student_names
	GROUP BY name
	HAVING COUNT(name) > 1
	) as subquery
	
-- SELECT 
-- 	COUNT(name)	
-- FROM 
-- 	(SELECT name,
-- 			COUNT(name)
-- 	FROM student_names
-- 	GROUP BY name
-- 	HAVING COUNT(name) = 1
-- 	) subquery


--- Finding unique names
-- SELECT 
-- 	COUNT(*) as unique_student_cnt
-- FROM 
-- 	(
-- 	SELECT 
-- 		name,
-- 		COUNT(name) as cnt
-- 	FROM student_names	
-- 	GROUP BY name
-- 	HAVING COUNT(name) = 1
-- 	) subquery