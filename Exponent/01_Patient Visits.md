## Patient Visits

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Link** | https://www.tryexponent.com/practice/prepare/patient-visits |

---

#### Problem Statement

You are given a healthcare database with three tables: `provider`, `patient`, and `visit`. Providers have specialties, patients have demographic information, and visits link patients to providers with referral and date information.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS visit;
DROP TABLE IF EXISTS patient;
DROP TABLE IF EXISTS provider;

CREATE TABLE provider (
    provider_id INTEGER,
    provider_specialty VARCHAR(50)
);

CREATE TABLE patient (
    patient_id INTEGER,
    patient_name VARCHAR(50),
    sex INTEGER,
    age INTEGER
);

CREATE TABLE visit (
    provider_id INTEGER,
    patient_id INTEGER,
    is_visit_referral INTEGER,
    visit_date TIMESTAMP
);

INSERT INTO provider (provider_id, provider_specialty) VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Pediatrics'),
(4, 'Neurology');

INSERT INTO patient (patient_id, patient_name, sex, age) VALUES
(1, 'Alice', 0, 25),
(2, 'Bob', 1, 45),
(3, 'Charlie', 1, 15),
(4, 'Diana', 0, 60),
(5, 'Eve', 0, 11);

INSERT INTO visit (provider_id, patient_id, is_visit_referral, visit_date) VALUES
(1, 1, 1, '2026-02-01 10:00:00'),
(2, 2, 0, '2026-03-02 11:00:00'),
(2, 2, 1, '2026-04-05 10:00:00'),
(2, 2, 0, '2026-05-01 10:00:00'),
(3, 3, 1, '2026-03-10 14:00:00'),
(4, 4, 1, '2026-04-15 09:00:00');
```

---

#### Question 1
Write a SQL query to list the number of patient visits, categorized by provider specialty. Output columns: `provider_specialty`, `total_visits`.

#### Solution
```sql
SELECT
    provider.provider_specialty,
    COUNT(DISTINCT visit.patient_id) AS total_visits
FROM visit
JOIN provider ON visit.provider_id = provider.provider_id
GROUP BY 1;
```

#### Sample Output

| provider_specialty | total_visits |
|--------------------|--------------|
| Cardiology         | 1            |
| Neurology          | 2            |
| Pediatrics         | 1            |

---

#### Question 2
Write a SQL query to list the percentage of patients referred by each provider over the past 90 days. Output columns: `provider_specialty`, `referral_percentage`.

#### Solution
```sql
SELECT
    ROUND(SUM(is_visit_referral) * 100.00 / COUNT(*), 4) AS referral_percentage
FROM visit
WHERE visit_date BETWEEN DATE('2026-05-21') - 90 AND DATE('2026-05-21');
```

#### Sample Output

| referral_percentage |
|---------------------|
| 50.0000             |

---

#### Question 3
Write a SQL query to list the most common sex of patients seen by each provider specialty, where sex is represented as 0 for female and 1 for male. Output columns: `provider_specialty`, `majority_sex`, `majority_count`.

#### Solution
```sql
WITH gender_rnk AS (
    SELECT
        provider.provider_specialty,
        patient.sex AS majority_sex,
        COUNT(patient.sex) AS majority_count,
        DENSE_RANK() OVER (PARTITION BY provider.provider_specialty ORDER BY COUNT(patient.sex)) AS rnk
    FROM visit
    JOIN provider ON visit.provider_id = provider.provider_id
    JOIN patient ON visit.patient_id = patient.patient_id
    GROUP BY 1, 2
)
SELECT
    provider_specialty,
    CASE WHEN majority_sex = 0 THEN 'female' ELSE 'male' END AS majority_sex,
    majority_count
FROM gender_rnk
WHERE rnk = 1
ORDER BY provider_specialty;
```

#### Sample Output

| provider_specialty | majority_sex | majority_count |
|--------------------|--------------|----------------|
| Cardiology         | female       | 1              |
| Neurology          | female       | 1              |
| Pediatrics         | male         | 1              |

---

#### Question 4
Write a SQL query to identify the most frequently seen neurologist (provider_specialty = 'Neurology') for each patient over the past 3 months. Exclude patients with fewer than 3 visits to the same provider. Output columns: `patient_id`, `provider_id`, `visit_count`.

#### Solution
```sql
WITH FilteredVisits AS (
    SELECT
        v.patient_id,
        v.provider_id,
        COUNT(*) AS visit_count
    FROM visit v
    JOIN provider p ON v.provider_id = p.provider_id
    WHERE v.visit_date >= DATE('now', '-3 months')
      AND p.provider_specialty = 'Neurology'
    GROUP BY v.patient_id, v.provider_id
    HAVING COUNT(*) >= 3
),
RankedProviders AS (
    SELECT
        fv.patient_id,
        fv.provider_id,
        fv.visit_count,
        ROW_NUMBER() OVER (PARTITION BY fv.patient_id ORDER BY fv.visit_count DESC) AS rn
    FROM FilteredVisits fv
)
SELECT
    patient_id,
    provider_id,
    visit_count
FROM RankedProviders
WHERE rn = 1;
```

#### Sample Output

| patient_id | provider_id | visit_count |
|------------|-------------|-------------|
| 2          | 2           | 3           |

---

#### Question 5 (Hard)
Write a SQL query to rank provider specialties by the fastest month-over-month growth in Medicare patients (ages over 10), comparing this month to last month. Output columns: `provider_specialty`, `monthly_growth`, `rank`.

#### Solution
```sql
WITH cte1 AS (
    SELECT
        p.provider_specialty,
        STRFTIME('%Y-%m', v.visit_date) AS mnth_yr,
        COUNT(*) AS patients_seen
    FROM visit v
    JOIN provider p ON v.provider_id = p.provider_id
    JOIN patient pa ON v.patient_id = pa.patient_id
    WHERE pa.age > 10
    GROUP BY 1, 2
    ORDER BY 1, 2
),
grwth AS (
    SELECT
        *,
        COALESCE(LAG(patients_seen) OVER (PARTITION BY provider_specialty ORDER BY mnth_yr), 0) AS prev_mnth_patient_seen,
        (patients_seen - COALESCE(LAG(patients_seen) OVER (PARTITION BY provider_specialty ORDER BY mnth_yr), 0)) AS mom_growth
    FROM cte1
)
SELECT
    provider_specialty,
    mom_growth,
    DENSE_RANK() OVER (PARTITION BY provider_specialty ORDER BY mom_growth DESC) AS rnk
FROM grwth;
```

#### Sample Output

| provider_specialty | mom_growth | rnk |
|--------------------|------------|-----|
| Cardiology         | 1          | 1   |
| Neurology          | 3          | 1   |
| Pediatrics         | 1          | 1   |