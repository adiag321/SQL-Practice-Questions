## Top Rated Businesses

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · CASE WHEN · Percentage |
| **Companies** | Yelp |
| **Link** | https://datalemur.com/questions/sql-top-businesses |

---

#### Problem Statement

Given a reviews table, write a query to find the **count of businesses with 4+ star reviews** and the **percentage of such businesses** (as a whole number) out of all reviewed businesses.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS reviews;

CREATE TABLE reviews (
    business_id  INTEGER,
    user_id      INTEGER,
    review_stars INTEGER,
    review_date  DATE
);

INSERT INTO reviews (business_id, user_id, review_stars, review_date) VALUES
(1, 101, 4, '2022-01-01'),
(2, 102, 5, '2022-02-01'),
(3, 103, 3, '2022-03-01'),
(4, 104, 2, '2022-04-01'),
(5, 105, 4, '2022-05-01');
-- top-rated (>=4): businesses 1, 2, 5 → count = 3, pct = 3/5 * 100 = 60
```

---

#### Solution

```sql
SELECT
    SUM(CASE WHEN review_stars >= 4 THEN 1 ELSE 0 END) AS business_count,
    SUM(CASE WHEN review_stars >= 4 THEN 1 ELSE 0 END) * 100 / COUNT(*) AS top_rated_pct
FROM reviews;
```

---

#### Sample Output

| business_count | top_rated_pct |
|----------------|---------------|
| 3              | 60            |
