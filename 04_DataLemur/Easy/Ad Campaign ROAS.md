## Ad Campaign ROAS

| Attribute | Detail |
|-----------|--------|
| **Difficulty** | Easy |
| **Tags** | Aggregation · ROUND |
| **Companies** | TechTFQ |
| **Link** | https://datalemur.com/questions/ad-campaign-roas |

---

#### Problem Statement

Given a table of ad campaigns, write a query to calculate the **Return on Ad Spend (ROAS)** for each advertiser. Round the result to 2 decimal places and order by `advertiser_id`.

`ROAS = total revenue / total spend`

---

#### Create & Insert Statements

```sql
DROP TABLE IF EXISTS ad_campaigns;

CREATE TABLE ad_campaigns (
    advertiser_id INTEGER,
    campaign_id   INTEGER,
    spend         DECIMAL(10, 2),
    revenue       DECIMAL(10, 2)
);

INSERT INTO ad_campaigns (advertiser_id, campaign_id, spend, revenue) VALUES
(1, 1, 5000.00, 7500.00),
(1, 2, 1000.00, 900.00),
(2, 3, 3000.00, 12000.00),
(3, 4,  500.00,  250.00),
(3, 5, 2000.00, 6000.00);
```

---

#### Solution

```sql
SELECT advertiser_id, ROUND((SUM(revenue) / SUM(spend))::DECIMAL, 2) AS ROAS
FROM ad_campaigns
GROUP BY advertiser_id
ORDER BY advertiser_id;
```

---

#### Sample Output

| advertiser_id | ROAS |
|---------------|------|
| 1             | 1.41 |
| 2             | 4.00 |
| 3             | 2.50 |
