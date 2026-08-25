## Marketing Campaign Duration

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Link** | https://www.tryexponent.com/courses/sql-interviews/marketing-campaign-duration |

---

#### Problem Statement

You are given 3 tables, `campaign`, `user`, and `transaction`, with the following columns:

`campaign`: `upsell_campaign_id`, `date_start`, `date_end`

`user`: `user_id`, `name`, `is_eligible_for_upsell_campaign`

`transaction`: `transaction_id`, `user_id`, `product_id`, `transaction_date`, `quantity`

Write a SQL query that calculates the average total duration of campaigns.

*Note: a campaign may span multiple date ranges across rows. Sum the total duration per campaign first, then average.*

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS "transaction";
DROP TABLE IF EXISTS "user";
DROP TABLE IF EXISTS campaign;

CREATE TABLE campaign (
    upsell_campaign_id INTEGER,
    date_start DATE,
    date_end DATE
);

CREATE TABLE "user" (
    user_id INTEGER,
    name VARCHAR(50),
    is_eligible_for_upsell_campaign BOOLEAN
);

CREATE TABLE "transaction" (
    transaction_id INTEGER,
    user_id INTEGER,
    product_id INTEGER,
    transaction_date TIMESTAMP,
    quantity INTEGER
);

INSERT INTO campaign (upsell_campaign_id, date_start, date_end) VALUES
(1, '2024-01-01', '2024-01-05'),
(1, '2024-02-01', '2024-02-03'),
(2, '2024-03-01', '2024-03-10');

INSERT INTO "user" (user_id, name, is_eligible_for_upsell_campaign) VALUES
(1, 'Alice', 1),
(2, 'Bob', 0);

INSERT INTO "transaction" (transaction_id, user_id, product_id, transaction_date, quantity) VALUES
(1, 1, 101, '2024-01-02', 2),
(2, 2, 102, '2024-03-05', 1);
```

---

#### Solution

```sql
SELECT AVG(total_duration) AS avg_campaign_length
FROM (
    SELECT
        upsell_campaign_id,
        SUM(date_end - date_start) AS total_duration
    FROM campaign
    GROUP BY upsell_campaign_id
) AS campaign_totals;
```

---

#### Sample Output

| avg_campaign_length |
|----------------------|
| 7.5                   |
