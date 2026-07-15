-- Day 16/30 SQL Challenge
/*
-- TikTok Interview Question for data analyst
Q.1 Find the median within a series of numbers in SQL ;

1 8 3 4 5 odd 
1 3 4 5 8 9 even 
*/

-- Create TikTok table
CREATE TABLE tiktok (views INT);
-- Insert records
INSERT INTO tiktok (views) 
VALUES 
	(100), (800), (350), 
	(150), (600), 
	(700), (700), (950),
	(400), (300), (200);

-- ---------------------------------
-- My Solution
-- ---------------------------------
WITH CTE
AS (
	SELECT 
		views,
		ROW_NUMBER() OVER( ORDER BY views ASC) rn_asc,
		ROW_NUMBER() OVER( ORDER BY views DESC) rn_desc
	FROM tiktok
	WHERE views < 900
)
SELECT 
	AVG(views) as median
FROM CTE 
WHERE ABS(rn_asc - rn_desc) <= 1    -- 0 or 1
-- ORDER BY views;

n + 1/2

7+1/2 = 4th 


200/1 = 200 

200+300/2 = 250