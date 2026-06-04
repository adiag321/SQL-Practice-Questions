## Average Review Ratings

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · GROUP BY · Date Functions |
| **Companies** | Amazon |
| **Link** | https://datalemur.com/questions/sql-avg-review-ratings |

---

#### Problem Statement

Given a table of product reviews, write a query to retrieve the **average star rating** for each product, grouped by month. The output should display the month as a numerical value, product ID, and average star rating rounded to **2 decimal places**. Sort by month and then product ID.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS reviews;

CREATE TABLE reviews (
    review_id   INTEGER,
    user_id     INTEGER,
    submit_date TIMESTAMP,
    product_id  INTEGER,
    stars       INTEGER  -- 1 to 5
);

INSERT INTO reviews (review_id, user_id, submit_date, product_id, stars) VALUES
(1, 101, '2022-06-08 00:00:00', 50001, 4),
(2, 105, '2022-06-14 00:00:00', 69852, 4),
(3, 101, '2022-06-18 00:00:00', 50001, 3),
(4, 101, '2022-07-01 00:00:00', 69852, 3),
(5, 104, '2022-07-14 00:00:00', 50001, 5),
(6, 103, '2022-07-26 00:00:00', 69852, 4);
```

---

#### Solution

```sql
SELECT DATE_PART('MONTH', submit_date) AS mth, product_id, ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY DATE_PART('MONTH', submit_date), product_id
ORDER BY DATE_PART('MONTH', submit_date), product_id;
```

---

#### Sample Output

| mth | product_id | avg_stars |
|-----|------------|-----------|
| 6   | 50001      | 3.50      |
| 6   | 69852      | 4.00      |
| 7   | 50001      | 5.00      |
| 7   | 69852      | 3.50      |
