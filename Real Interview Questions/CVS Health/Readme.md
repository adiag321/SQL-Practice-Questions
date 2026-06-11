### CVS Health SQL Interview Questions

Consider the tables below and answer the following questions. Note that mem1 and mem2 splits the entire membership data into 2 tables

```text
mem1                                  mem2
+---------------+---------+           +---------------+---------+
| id            | int     |<---->+--->| id            | int     |
| gender_cd     | varchar |      |    | gender_cd     | varchar |
| age_band      | varchar |      |    | age_band      | varchar |
| zip_cd        | varchar |      |    | zip_cd        | varchar |
+---------------+---------+      |    +---------------+---------+
                                 |      
                                 |  
                                 |    clm
rsk                              |    +--------------------+---------+
+---------------+---------+      |    | claim_id           | int     |
| id            | int     |<-----+--->| id                 | int     |
| srv_start_dt  | date    |           | srv_start_dt       | date    |
| retro_risk    | double  |           | paid_prvdr_par_cd  | varchar |
| prosp_risk    | double  |           | srv_spclty_ctg_cd  | varchar |
+---------------+---------+           | cost_ctg_short_nm  | varchar |
                                      | paid_amt           | double  |
                                      | billed_amt         | double  |
                                      +--------------------+---------+
```


#### Create and Insert Statements

```sql
-- 1. CREATE TABLES
CREATE TABLE mem1 (
    id INT,
    gender_cd VARCHAR(10),
    age_band VARCHAR(20),
    zip_cd VARCHAR(10)
);

CREATE TABLE mem2 (
    id INT,
    gender_cd VARCHAR(10),
    age_band VARCHAR(20),
    zip_cd VARCHAR(10)
);

CREATE TABLE rsk (
    id INT,
    srv_start_dt DATE,
    retro_risk float,
    prosp_risk float
);

CREATE TABLE clm (
    claim_id INT,
    id INT,
    srv_start_dt DATE,
    paid_prvdr_par_cd VARCHAR(10),
    srv_spclty_ctg_cd VARCHAR(50),
    cost_ctg_short_nm VARCHAR(50),
    paid_amt float,
    billed_amt float
);

-- 2. INSERT MOCK DATA
-- Insert into mem1 and mem2 (representing the split membership data)
INSERT INTO mem1 (id, gender_cd, age_band, zip_cd) VALUES 
(1, 'M', '18-34', '78701'),
(2, 'F', '35-50', '78702');

INSERT INTO mem2 (id, gender_cd, age_band, zip_cd) VALUES 
(3, 'M', '51-64', '78703'),
(4, 'F', '65+', '78704');

-- Insert into clm (Claims data)
-- Note: Including 2018 dates for Q2 and Q3
INSERT INTO clm (claim_id, id, srv_start_dt, paid_prvdr_par_cd, srv_spclty_ctg_cd, cost_ctg_short_nm, paid_amt, billed_amt) VALUES 
(101, 1, '2018-05-10', 'Y', 'Cardiology', 'Outpatient', 1500.00, 2000.00),
(102, 1, '2018-06-15', 'Y', 'Cardiology', 'Outpatient', 1200.00, 1800.00),
(103, 2, '2018-07-20', 'N', 'Orthopedics', 'Inpatient', 5000.00, 8000.00),
(104, 3, '2018-08-25', 'Y', 'Cardiology', 'Outpatient', 2000.00, 2500.00),
(105, 4, '2019-01-10', 'Y', 'Orthopedics', 'Outpatient', 800.00, 1000.00), -- Non-2018 record
(106, 2, '2018-11-05', 'Y', 'Orthopedics', 'Inpatient', 4500.00, 7000.00);

-- Insert into rsk (Risk data - included for completeness though not explicitly needed for the specific questions)
INSERT INTO rsk (id, srv_start_dt, retro_risk, prosp_risk) VALUES 
(1, '2018-01-01', 1.2, 1.5),
(2, '2018-01-01', 0.9, 1.1);
```

#### Questions

###### 1. What is the sum of paid_amount by provider specialty in 2018?

```sql
SELECT
    srv_spclty_ctg_cd,
    SUM(paid_amt) AS total_amt
FROM clm
WHERE EXTRACT(YEAR FROM srv_start_dt) = 2018
GROUP BY 1
ORDER BY total_amt DESC;
```

##### Expected Output

| srv_spclty_ctg_cd | total_amt |
|-------------------|-----------|
| Cardiology        | 4700.00   |
| Orthopedics       | 9500.00   |

###### 2. What is the % paid_amount out of total anual paid_amount by provider specialty in 2018?

```sql
Select
    srv_spclty_ctg_cd,
    sum(paid_amt) as total_amt,
    (SELECT SUM(paid_amt) FROM clm WHERE EXTRACT(YEAR FROM srv_start_dt) = 2018) AS total_annual_paid_amt
    sum(paid_amt)*100.00/(Select sum(paid_amt) as total_annual_paid_amt from clm Where extract(year from srv_start_dt) = 2018) as paid_amt_perc
From clm
Where extract(year from srv_start_dt) = 2018
Group by 1
Order by 2 desc;
```

##### Expected Output

| srv_spclty_ctg_cd | total_amt | paid_amt_perc |
|-------------------|-----------|---------------|
| Cardiology        | 4700.00   | 47.00         |
| Orthopedics       | 9500.00   | 95.00         |

###### 3. (optional) for each srv_spclty_ctg_cd, which age_band has most number of claims?

```sql
with total_mbrship as (
    select id, age_band from mem1
    union all
    select id, age_band from mem2
),
claim_age_bnd as (select
c.srv_spclty_ctg_cd,
mem.age_band,
count(distinct claim_id) as unique_clms
from total_mbrship as mem 
left join clm as c
on mem.id = c.id
group by 1,2
), 
rnk_claims as (select
*,
dense_rank() over(partition by srv_spclty_ctg_cd order by unique_clms desc) as rnk
from claim_age_bnd
)
select
*
from rnk_claims
where rnk = 1
order by srv_spclty_ctg_cd, age_band;
```

##### Expected Output

| srv_spclty_ctg_cd | age_band    | unique_clms | rnk |
|-------------------|-----------|---------------|-----|
| Cardiology        | 18-34     | 1             | 1   |
| Orthopedics       | 35-50     | 1             | 1   |
| Orthopedics       | 65+       | 1             | 1   |
| Orthopedics       | 51-64     | 1             | 1   |