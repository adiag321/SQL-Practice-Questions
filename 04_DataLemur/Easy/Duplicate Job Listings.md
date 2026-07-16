## Duplicate Job Listings

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Self JOIN · COUNT DISTINCT |
| **Companies** | LinkedIn |
| **Link** | https://datalemur.com/questions/duplicate-job-listings |

---

#### Problem Statement

Given a table of job listings, write a query to find the **number of companies** that have posted duplicate job listings (i.e., the same title and description, but different `job_id`).

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS job_listings;

CREATE TABLE job_listings (
    job_id      INTEGER,
    company_id  INTEGER,
    title       VARCHAR(100),
    description TEXT
);

INSERT INTO job_listings (job_id, company_id, title, description) VALUES
-- Company 1: two identical job posts → duplicate
(1, 1, 'Data Analyst', 'Analyze data and build dashboards'),
(2, 1, 'Data Analyst', 'Analyze data and build dashboards'),
-- Company 1: different title → not a duplicate pair
(3, 1, 'Data Engineer', 'Build ETL pipelines'),
-- Company 2: unique posting → not a duplicate
(4, 2, 'ML Engineer', 'Build ML models'),
-- Company 3: two identical posts → duplicate
(5, 3, 'Software Engineer', 'Write backend code'),
(6, 3, 'Software Engineer', 'Write backend code');
```

---

#### Solution

```sql
SELECT COUNT(DISTINCT t1.company_id) AS co_w_duplicate_jobs
FROM job_listings t1
JOIN job_listings t2 ON t1.company_id = t2.company_id
WHERE t1.title = t2.title
  AND t1.description = t2.description
  AND t1.job_id != t2.job_id;
```

---

#### Sample Output

| co_w_duplicate_jobs |
|---------------------|
| 2                   |
