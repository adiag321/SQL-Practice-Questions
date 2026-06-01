## App Click-through Rate (CTR)

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · CASE WHEN · CTR |
| **Companies** | Facebook |

---

#### Problem Statement

Assume you have an `events` table on Facebook app analytics. Write a query to calculate the click-through rate (CTR) for each app in 2022 and round the results to 2 decimal places.

Percentage of click-through rate (CTR) = `100.0 * Number of clicks / Number of impressions`

---

#### Table Used

**`events`**

| Column | Type |
|--------|------|
| app_id | integer |
| event_type | string |
| timestamp | datetime |

---

#### Solution

```sql
SELECT 
app_id, 
ROUND(
  100.0 * SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) 
  / SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 
  2
) AS ctr
FROM events
WHERE DATE_PART('YEAR', timestamp) = 2022
GROUP BY app_id;
```

---

#### Sample Output

| app_id | ctr |
|--------|-----|
| 123 | 50.00 |
| 234 | 100.00 |
