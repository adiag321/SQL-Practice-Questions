## User pairs from same country.

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |
| **Tags** | SELF JOIN |
| **Companies** | LinkedIn |

---

#### Problem Statement

Find all unique pairs of users who are from the same country.

---

#### Table Used

**`users`**

| Column | Type |
|--------|------|
| user_id | INT |
| signup_date | DATE |
| country | TEXT |
| plan | TEXT |

```sql
CREATE TABLE users (
    user_id     INT PRIMARY KEY,
    signup_date DATE,
    country     TEXT,
    plan        TEXT
);
```

---

#### Solution

```sql
-- Same-country user pairs
select
u1.country,
u1.user_id as userid_1,
u1.signup_date as user1_signup_date,
u1.plan as user1_plan,
u2.user_id as userid_2,
u2.signup_date as user2_signup_date,
u2.plan as user2_plan
from users as u1
join users as u2
on u1.country = u2.country
and u1.user_id < u2.user_id
order by 1
```

---

#### Explanation

This query identifies unique pairs of users who reside in the same country using a self-join.

- The `users` table is aliased as `u1` and `u2` to join it with itself.
- The join condition `u1.country = u2.country` ensures that only users from the same country are paired.
- The condition `u1.user_id < u2.user_id` is crucial for two reasons:
    - It prevents duplicate pairs (e.g., (user A, user B) and (user B, user A)).
    - It excludes self-pairing (e.g., (user A, user A)).
- The `ORDER BY 1` clause sorts the results by country.

---

#### Sample Output

| country | userid_1 | user1_signup_date | user1_plan | userid_2 | user2_signup_date | user2_plan |
|---------|----------|-------------------|------------|----------|-------------------|------------|
| CA      | 4        | 2024-02-01        | free       | 8        | 2024-02-10        | premium    |
| UK      | 2        | 2024-01-05        | free       | 6        | 2024-03-01        | free       |
| US      | 1        | 2024-01-01        | premium    | 3        | 2024-01-10        | premium    |
| US      | 1        | 2024-01-01        | premium    | 5        | 2024-02-15        | premium    |
| US      | 1        | 2024-01-01        | premium    | 7        | 2024-01-20        | free       |
| US      | 3        | 2024-01-10        | premium    | 5        | 2024-02-15        | premium    |
