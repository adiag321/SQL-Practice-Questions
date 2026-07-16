## LinkedIn Power Creators (Part 1)

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | JOIN · Filtering |
| **Companies** | LinkedIn |
| **Link** | https://datalemur.com/questions/linkedin-power-creators |

---

#### Problem Statement

Given tables of LinkedIn personal profiles and company pages, write a query to find all personal profiles where the **profile's follower count exceeds their employer's company page follower count**. Output `profile_id` ordered ascending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS personal_profiles;
DROP TABLE IF EXISTS company_pages;

CREATE TABLE personal_profiles (
    profile_id  INTEGER,
    name        VARCHAR(100),
    followers   INTEGER,
    employer_id INTEGER
);

CREATE TABLE company_pages (
    company_id INTEGER,
    name       VARCHAR(100),
    followers  INTEGER
);

INSERT INTO company_pages (company_id, name, followers) VALUES
(1, 'Google',    500000),
(2, 'Meta',      300000),
(3, 'Airbnb',    100000);

INSERT INTO personal_profiles (profile_id, name, followers, employer_id) VALUES
(1, 'Alice',  600000, 1),  -- 600k > 500k (Google) → included
(2, 'Bob',    200000, 2),  -- 200k < 300k (Meta) → excluded
(3, 'Carol',  150000, 3),  -- 150k > 100k (Airbnb) → included
(4, 'Dave',    80000, 3);  -- 80k < 100k (Airbnb) → excluded
```

---

#### Solution

```sql
SELECT profile_id
FROM personal_profiles pf
INNER JOIN company_pages cp ON pf.employer_id = cp.company_id
WHERE pf.followers > cp.followers
ORDER BY profile_id;
```

---

#### Sample Output

| profile_id |
|------------|
| 1          |
| 3          |
