## Find Campaign Purchases

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Medium |

---

#### Problem Statement

You are given three tables: campaign (upsell_campaign_id, date_start, date_end), user (user_id, name, is_eligible_for_upsell_campaign), and transaction (transaction_id, user_id, product_id, transaction_date, quantity). List the number of users for each campaign who were eligible for an upsell and purchased something.

---

#### Create & Insert Statements

The following data is illustrative and is included to make the query executable.

```sql
CREATE TABLE campaign (upsell_campaign_id INTEGER PRIMARY KEY, date_start DATE, date_end DATE);
CREATE TABLE users (user_id INTEGER PRIMARY KEY, name TEXT, is_eligible_for_upsell_campaign BOOLEAN);
CREATE TABLE transactions (transaction_id INTEGER PRIMARY KEY, user_id INTEGER, product_id INTEGER, transaction_date DATE, quantity INTEGER);

INSERT INTO campaign VALUES
(1, '2024-01-01', '2024-01-31'),
(2, '2024-02-01', '2024-02-29');

INSERT INTO users VALUES
(1, 'Ana', TRUE), (2, 'Bo', TRUE), (3, 'Cy', FALSE);

INSERT INTO transactions VALUES
(101, 1, 10, '2024-01-15', 1), (102, 1, 11, '2024-02-10', 1),
(103, 2, 12, '2024-02-20', 2), (104, 3, 13, '2024-01-10', 1);
```

---

#### Solution

Assumption: a user counts once per campaign when they have a positive-quantity transaction during the campaign dates. The source schema has no campaign-to-user mapping, so eligibility is treated as the user-level flag.

```sql
-- postgresql

SELECT
    c.upsell_campaign_id,
    COUNT(DISTINCT u.user_id) AS eligible_purchasing_users
FROM campaign AS c
JOIN transactions AS t
    ON t.transaction_date BETWEEN c.date_start AND c.date_end
JOIN users AS u
    ON u.user_id = t.user_id
WHERE u.is_eligible_for_upsell_campaign
  AND t.quantity > 0
GROUP BY c.upsell_campaign_id
ORDER BY c.upsell_campaign_id;
```

---

#### Sample Output

| upsell_campaign_id | eligible_purchasing_users |
|---------------------|---------------------------|
| 1 | 1 |
| 2 | 2 |

