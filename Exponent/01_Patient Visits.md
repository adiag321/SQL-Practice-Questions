## Patient Visits

Exponent Link: [https://www.tryexponent.com/practice/prepare/patient-visits](https://www.tryexponent.com/practice/prepare/patient-visits)

#### Tables Used

**`provider`**

| Column | Type |
|--------|------|
| provider_id | INTEGER |
| provider_specialty | VARCHAR |

**`patient`**

| Column | Type |
|--------|------|
| patient_id | INTEGER |
| patient_name | VARCHAR |
| sex | INTEGER |
| age | INTEGER |

**`visit`**

| Column | Type |
|--------|------|
| provider_id | INTEGER |
| patient_id | INTEGER |
| is_visit_referral | INTEGER |
| visit_date | TIMESTAMP |

---

#### Schema & Data Setup

```sql
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
Write a SQL query to list the number of patient visits, categorized by provider specialty. Output columns: `provider_specialty`, `total_visits`

#### Solution
```sql
select
provider.provider_specialty,
count(distinct visit.patient_id) as total_visit
from visit 
join provider
on visit.provider_id = provider.provider_id
group by 1;
```

---

#### Question 2
Write a SQL query to list the percentage of patients referred by each provider over the past 90 days. Output columns: `provider_specialty`, `referral_percentage`

#### Solution
```sql
select
round(sum(is_visit_referral)*100.00/count(*), 4)
from visit
where visit_date between date('2026-05-21')-90 and Date('2026-05-21');
```

---

#### Question 3
Write a SQL query to list the most common sex of patients seen by each provider specialty, where sex is represented as 0 for female and 1 for male. Output column: `provider_specialty`, `majority_sex`, `majority_count`

#### Solution
```sql
with gender_rnk as (select
provider.provider_specialty,
patient.sex as majority_sex,
count(patient.sex) as majority_count,
dense_rank() over(partition by provider.provider_specialty order by count(patient.sex)) as rnk
from visit
join provider
on visit.provider_id = provider.provider_id
join patient
on visit.patient_id = patient.patient_id
group by 1,2
)
select
provider_specialty,
case when majority_sex = 0 then 'female' else 'male' end as majority_sex,
majority_count
from gender_rnk
where rnk = 1
order by provider_specialty;
```

---

#### Question 4
Write a SQL query to identify the most frequently seen neurologist (provider_specialty = neurology) for each patient over the past 3 months. Exclude patients with fewer than 3 visits to the same provider. Output column: `patient_id`, `provider_id`, `visit_count`

#### Solution
```sql
WITH FilteredVisits AS (
    SELECT 
        v.patient_id,
        v.provider_id,
        COUNT(*) AS visit_count
    FROM 
        visit v
    JOIN 
        provider p ON v.provider_id = p.provider_id
    WHERE 
        v.visit_date >= DATE('now', '-3 months')
        AND p.provider_specialty = 'Neurology'   -- Filter for neurologists
    GROUP BY 
        v.patient_id, 
        v.provider_id
    HAVING 
        COUNT(*) >= 3  -- Exclude providers with fewer than 3 visits
),
RankedProviders AS (
    SELECT 
        fv.patient_id,
        fv.provider_id,
        fv.visit_count,
        ROW_NUMBER() OVER (PARTITION BY fv.patient_id ORDER BY fv.visit_count DESC) AS rn
    FROM 
        FilteredVisits fv
)
SELECT 
    patient_id, 
    provider_id, 
    visit_count
FROM 
    RankedProviders
WHERE 
    rn = 1;  -- Select the most frequently seen neurologist for each patient
```

---

#### Question 5 (HARD)
Write a SQL query to rank provider specialties by the fastest month-over-month growth in Medicare patients (ages over 10), comparing this month to last month. Output columns: `provider_specialty`, `monthly_growth`, `rank`

#### Solution
```sql
with cte1 as (select
p.provider_specialty,
strftime('%Y-%m', v.visit_date) as mnth_yr,
count(*) as patients_seen
from visit v
join provider p
on v.provider_id = p.provider_id
join patient as pa
on v.patient_id = pa.patient_id
where pa.age>10
group by 1,2
order by 1,2
),
grwth as (select
*,
coalesce(lag(patients_seen) over(partition by provider_specialty order by mnth_yr),0) as prev_mnth_patient_seen,
(patients_seen - coalesce(lag(patients_seen) over(partition by provider_specialty order by mnth_yr),0)) as mom_growth
from cte1
)
select
provider_specialty,
mom_growth,
dense_rank() over(partition by provider_specialty order by mom_growth desc) as rnk
from grwth;
```