## Unfinished Parts

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Filtering · IS NULL |
| **Companies** | Tesla |
| **Link** | https://datalemur.com/questions/tesla-unfinished-parts |

---

#### Problem Statement

Given a table of assembly parts, write a query to find all parts that have **not yet been finished** (i.e., `finish_date IS NULL`). Output `part` and `assembly_step`.

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS parts_assembly;

CREATE TABLE parts_assembly (
    part          VARCHAR(50),
    finish_date   DATE,
    assembly_step INTEGER
);

INSERT INTO parts_assembly (part, finish_date, assembly_step) VALUES
('battery',    '2022-01-01', 1),
('battery',    '2022-02-01', 2),
('battery',    NULL,         3),  -- unfinished → included
('bumper',     '2022-01-15', 1),
('bumper',     NULL,         2),  -- unfinished → included
('engine',     '2022-03-01', 1);
```

---

#### Solution

```sql
SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;
```

---

#### Sample Output

| part    | assembly_step |
|---------|---------------|
| battery | 3             |
| bumper  | 2             |
