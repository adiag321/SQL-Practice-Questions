# 3832. Find Users with Persistent Behavior Patterns

## Problem Description

Write a solution to identify **behaviorally stable** users based on the following definition:

- A user is considered behaviorally stable if there exists a sequence of **at least 5 consecutive days** such that:
  - The user performed exactly **one action per day** during that period.
  - The action is the **same** on all those consecutive days.
- If a user has multiple qualifying sequences, only consider the sequence with the **maximum length**.

Return the result table ordered by `streak_length` in **descending** order, then by `user_id` in **ascending** order.

**Difficulty**: Hard

Link: https://leetcode.com/problems/find-users-with-persistent-behavior-patterns/

## Table Schema

### Activity Table

| Column Name | Type    |
|-------------|---------|
| user_id     | int     |
| action_date | date    |
| action      | varchar |

- `(user_id, action_date, action)` is the primary key (unique value) for this table.
- Each row represents a user performing a specific action on a given date.

## Schema Setup

```sql
CREATE TABLE activity (
    user_id INT,
    action_date DATE,
    action VARCHAR(20),
    PRIMARY KEY (user_id, action_date, action)
);

INSERT INTO activity (user_id, action_date, action)
VALUES
    (1, '2024-01-01', 'login'),
    (1, '2024-01-02', 'login'),
    (1, '2024-01-03', 'login'),
    (1, '2024-01-04', 'login'),
    (1, '2024-01-05', 'login'),
    (1, '2024-01-06', 'logout'),
    (2, '2024-01-01', 'click'),
    (2, '2024-01-02', 'click'),
    (2, '2024-01-03', 'click'),
    (2, '2024-01-04', 'click'),
    (3, '2024-01-01', 'view'),
    (3, '2024-01-02', 'view'),
    (3, '2024-01-03', 'view'),
    (3, '2024-01-04', 'view'),
    (3, '2024-01-05', 'view'),
    (3, '2024-01-06', 'view'),
    (3, '2024-01-07', 'view');
```

## Example

### Input

**Activity Table:**

| user_id | action_date | action |
|---------|-------------|--------|
| 1       | 2024-01-01  | login  |
| 1       | 2024-01-02  | login  |
| 1       | 2024-01-03  | login  |
| 1       | 2024-01-04  | login  |
| 1       | 2024-01-05  | login  |
| 1       | 2024-01-06  | logout |
| 2       | 2024-01-01  | click  |
| 2       | 2024-01-02  | click  |
| 2       | 2024-01-03  | click  |
| 2       | 2024-01-04  | click  |
| 3       | 2024-01-01  | view   |
| 3       | 2024-01-02  | view   |
| 3       | 2024-01-03  | view   |
| 3       | 2024-01-04  | view   |
| 3       | 2024-01-05  | view   |
| 3       | 2024-01-06  | view   |
| 3       | 2024-01-07  | view   |

### Output

| user_id | action | streak_length | start_date | end_date   |
|---------|--------|---------------|------------|------------|
| 3       | view   | 7             | 2024-01-01 | 2024-01-07 |
| 1       | login  | 5             | 2024-01-01 | 2024-01-05 |

### Explanation

- **User 1**: Performed `login` from `2024-01-01` to `2024-01-05` on consecutive days. Each day has exactly one action, and the action is the same. Streak length = **5** (meets minimum requirement). The action changes on `2024-01-06`, ending the streak.
- **User 2**: Performed `click` for only **4** consecutive days. Does not meet the minimum streak length of 5. Excluded from the result.
- **User 3**: Performed `view` for **7** consecutive days. This is the longest valid sequence for this user. Included in the result.

Results are ordered by `streak_length` (descending), then by `user_id` (ascending).

## Solution

```sql
WITH cte1 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY user_id, action ORDER BY action_date ASC) AS rnk
    FROM activity
),

cte2 AS (
    SELECT
        *,
        action_date - INTERVAL rnk DAY AS diff
    FROM cte1
)

SELECT
    user_id,
    action,
    COUNT(*) AS streak_length,
    MIN(action_date) AS start_date,
    MAX(action_date) AS end_date
FROM cte2
GROUP BY user_id, action, diff
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) DESC, user_id;
```

## Approach

This solution uses the **Consecutive Grouping (Islands and Gaps)** technique to detect streaks of consecutive days with the same action.

### Step 1 — Assign Row Numbers (`cte1`)

```sql
SELECT *, ROW_NUMBER() OVER (PARTITION BY user_id, action ORDER BY action_date ASC) AS rnk
FROM activity
```

For each `(user_id, action)` pair, assign a sequential `ROW_NUMBER` ordered by `action_date`. This creates a monotonically increasing rank within each user-action group.

| user_id | action_date | action | rnk |
|---------|-------------|--------|-----|
| 3       | 2024-01-01  | view   | 1   |
| 3       | 2024-01-02  | view   | 2   |
| 3       | 2024-01-03  | view   | 3   |
| 3       | 2024-01-04  | view   | 4   |
| 3       | 2024-01-05  | view   | 5   |
| 3       | 2024-01-06  | view   | 6   |
| 3       | 2024-01-07  | view   | 7   |

### Step 2 — Compute Group Identifier (`cte2`)

```sql
SELECT *, action_date - INTERVAL rnk DAY AS diff
FROM cte1
```

Subtracting the row number (as days) from `action_date` yields a **constant date** for rows that are part of the same consecutive streak. This is the key insight:

| user_id | action_date | action | rnk | diff       |
|---------|-------------|--------|-----|------------|
| 3       | 2024-01-01  | view   | 1   | 2023-12-31 |
| 3       | 2024-01-02  | view   | 2   | 2023-12-31 |
| 3       | 2024-01-03  | view   | 3   | 2023-12-31 |
| 3       | 2024-01-04  | view   | 4   | 2023-12-31 |
| 3       | 2024-01-05  | view   | 5   | 2023-12-31 |
| 3       | 2024-01-06  | view   | 6   | 2023-12-31 |
| 3       | 2024-01-07  | view   | 7   | 2023-12-31 |

> All consecutive dates produce the **same `diff`** value, which acts as a group identifier.

If there were a gap (e.g., missing `2024-01-04`), the `diff` would shift, creating a **new group** — effectively splitting the streak.

### Step 3 — Aggregate and Filter

```sql
GROUP BY user_id, action, diff
HAVING COUNT(*) >= 5
```

- **Group** by `(user_id, action, diff)` to isolate each consecutive streak.
- **Filter** with `HAVING COUNT(*) >= 5` to keep only streaks of at least 5 days.
- **Aggregate** to compute `streak_length`, `start_date`, and `end_date`.

## Complexity

- **Time Complexity**: O(n log n) — dominated by the `ROW_NUMBER` window function which requires sorting, where n is the number of rows in the activity table.
- **Space Complexity**: O(n) — for the intermediate CTEs storing ranked and grouped rows.