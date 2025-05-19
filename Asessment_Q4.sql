/* Q4 – Simplified CLV per customer */
WITH cust_tx AS (                     
    SELECT
        s.owner_id,
        s.confirmed_amount / 100          AS amt_naira,       
        s.confirmed_amount * 0.001 / 100  AS profit_naira    
    FROM savings_savingsaccount AS s
),

cust_agg AS (  -- aggregate per customer
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name,' ',u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())   AS tenure_months,
        COUNT(ct.owner_id)   AS total_transactions,
        AVG(ct.profit_naira)   AS avg_profit_per_txn,
        SUM(ct.profit_naira)     AS total_profit
    FROM users_customuser  u
    LEFT JOIN cust_tx   ct  ON ct.owner_id = u.id
    GROUP BY customer_id, name, tenure_months
)

SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,

    /* (total_txns / tenure) × 12 × avg_profit */
    ROUND(
        ( total_transactions / NULLIF(tenure_months,0) ) * 12 * avg_profit_per_txn,
        2
    ) AS estimated_clv
FROM cust_agg
ORDER BY estimated_clv DESC
LIMIT 100;  -- top 100 high CLV customers
