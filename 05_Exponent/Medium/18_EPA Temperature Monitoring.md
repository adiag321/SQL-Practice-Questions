## EPA Temperature Monitoring

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |

---

#### Problem Statement

The Environmental Protection Agency (EPA) monitors the daily temperatures of different cities to study climate change and its impact. The agency believes that extreme fluctuations in temperature, such as a sudden rise after a day of fall, can have adverse environmental effects.

You are given a table `city_temperatures`, with the following columns:

- `date` (date): The date of the recorded temperature.
- `temperature` (float): The temperature recorded on that date.

Write an SQL query to identify days when the temperature rose at least 5 degrees after falling at least 3 degrees. Return the date and the temperature of those days.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS city_temperatures;

CREATE TABLE city_temperatures (
    date DATE,
    temperature FLOAT
);

INSERT INTO city_temperatures (date, temperature) VALUES
('2024-01-01', 80),
('2024-01-02', 76),
('2024-01-03', 82),
('2024-01-04', 79),
('2024-01-05', 70),
('2024-01-06', 76),
('2024-01-07', 77);
```

---

#### Solution

```sql
-- postgresql

WITH cte1 AS (
    SELECT
        date,
        temperature AS day3_temp,
        LAG(temperature) OVER (ORDER BY date ASC) AS day2_temp,
        LAG(temperature, 2) OVER (ORDER BY date ASC) AS day1_temp
    FROM city_temperatures
)
SELECT
    date,
    day3_temp AS temperature
FROM cte1
WHERE day3_temp - day2_temp >= 5
  AND day1_temp - day2_temp >= 3
ORDER BY date;
```

---

#### Sample Output

| date       | temperature |
|------------|-------------|
| 2024-01-03 | 82          |
| 2024-01-06 | 76          |
