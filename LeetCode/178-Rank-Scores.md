# 178. Rank Scores

## Problem Description

Write a solution to find the rank of the scores. The ranking should be calculated according to the following rules:

- The scores should be ranked from the highest to the lowest.
- If there is a tie between two scores, both should have the same ranking.
- After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.

Return the result table ordered by score in descending order.

Link: https://leetcode.com/problems/rank-scores/

## Table Schema

### Scores Table

| Column Name | Type    |
|-------------|---------|
| id          | int     |
| score       | decimal |

- `id` is the primary key (column with unique values) for this table.
- Each row of this table contains the score of a game. Score is a floating point value with two decimal places.

## Example

### Input

**Scores Table:**

| id | score |
|----|-------|
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |

### Output

| score | rank |
|-------|------|
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |

## Solution

```sql
SELECT 
    score,
    DENSE_RANK() OVER (ORDER BY score DESC) AS rank
FROM Scores
ORDER BY score DESC;
```

## Approach

This problem requires dense ranking with no gaps in rank numbers:
1. Use `DENSE_RANK()` window function to assign ranks without gaps
2. `ORDER BY score DESC` ensures higher scores get lower rank numbers
3. Unlike `RANK()`, `DENSE_RANK()` ensures consecutive ranking (no holes between ranks)
4. Order the final result by score in descending order

**Note:** The key difference between `RANK()` and `DENSE_RANK()`:
- `RANK()`: Would produce ranks like 1, 1, 3, 4 (has gaps)
- `DENSE_RANK()`: Produces ranks like 1, 1, 2, 3 (no gaps)

## Complexity

- **Time Complexity**: O(n log n) due to sorting for ranking and ordering
- **Space Complexity**: O(n) for storing the results