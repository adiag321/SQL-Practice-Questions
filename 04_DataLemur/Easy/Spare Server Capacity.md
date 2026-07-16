## Spare Server Capacity

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | CTE · JOIN · Aggregation |
| **Companies** | Microsoft |
| **Link** | https://datalemur.com/questions/sql-spare-server-capacity |

---

#### Problem Statement

Given tables of datacenters and forecasted demand, write a query to find the **spare capacity** for each datacenter (monthly_capacity minus total forecasted demand). Order by `datacenter_id` ascending.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS datacenters;
DROP TABLE IF EXISTS forecasted_demand;

CREATE TABLE datacenters (
    datacenter_id    INTEGER,
    name             VARCHAR(100),
    monthly_capacity INTEGER
);

CREATE TABLE forecasted_demand (
    datacenter_id   INTEGER,
    month           INTEGER,
    monthly_demand  INTEGER
);

INSERT INTO datacenters (datacenter_id, name, monthly_capacity) VALUES
(1, 'DC East',  1000),
(2, 'DC West',  1500),
(3, 'DC South',  800);

INSERT INTO forecasted_demand (datacenter_id, month, monthly_demand) VALUES
(1, 1, 300),
(1, 2, 400),   -- total demand DC1 = 700 → spare = 300
(2, 1, 600),
(2, 2, 500),   -- total demand DC2 = 1100 → spare = 400
(3, 1, 250),
(3, 2, 300);   -- total demand DC3 = 550 → spare = 250
```

---

#### Solution

```sql
WITH CT AS (
    SELECT datacenter_id, SUM(monthly_demand) AS sum_cap
    FROM forecasted_demand
    GROUP BY datacenter_id
)

SELECT CT.datacenter_id, dc.monthly_capacity - CT.sum_cap AS spare_capacity
FROM CT, datacenters dc
WHERE CT.datacenter_id = dc.datacenter_id
ORDER BY CT.datacenter_id;
```

---

#### Sample Output

| datacenter_id | spare_capacity |
|---------------|----------------|
| 1             | 300            |
| 2             | 400            |
| 3             | 250            |
