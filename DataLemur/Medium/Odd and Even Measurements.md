## Odd and Even Measurements

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | Window Functions · Aggregation |
| **Companies** | DataLemur |
| **Link** | https://datalemur.com/questions/odd-and-even-measurements |

---

#### Problem Statement

For each day, compute the sum of measurement values for **odd‑ranked** rows and **even‑ranked** rows (based on a row number that increments per day). Return the day, `odd_sum`, and `even_sum`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS measurements;

CREATE TABLE measurements (
    measurement_id   INTEGER PRIMARY KEY,
    measurement_time TIMESTAMP,
    measurement_value DECIMAL(10,2)
);

INSERT INTO measurements (measurement_id, measurement_time, measurement_value) VALUES
(1, '2022-01-01 08:00:00', 10.5),
(2, '2022-01-01 12:00:00', 20.0),
(3, '2022-01-01 16:00:00', 15.5),
(4, '2022-01-02 09:00:00', 12.0),
(5, '2022-01-02 13:00:00', 18.5),
(6, '2022-01-02 17:00:00', 22.0);
```

---

#### Solution

```sql
WITH ct AS (
    SELECT measurement_id,
           CAST(measurement_time AS DATE) AS measurement_day,
           measurement_value,
           ROW_NUMBER() OVER (PARTITION BY CAST(measurement_time AS DATE) ORDER BY measurement_id) AS rn
    FROM measurements
)
SELECT measurement_day,
       SUM(CASE WHEN rn % 2 <> 0 THEN measurement_value END) AS odd_sum,
       SUM(CASE WHEN rn % 2 = 0 THEN measurement_value END) AS even_sum
FROM ct
GROUP BY measurement_day;
```

---

#### Sample Output

| measurement_day | odd_sum | even_sum |
|-----------------|---------|----------|
| 2022-01-01      | 26.0    | 20.0 |
| 2022-01-02      | 34.0    | 40.5 |
