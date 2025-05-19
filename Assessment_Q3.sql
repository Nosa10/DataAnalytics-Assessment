/* Q3 – Account Inactivity Alert */
SELECT
    p.id    AS plan_id,
    p.owner_id,
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END    AS type,
    DATE(t.last_txn)   AS last_transaction_date,
    COALESCE(DATEDIFF(CURDATE(), t.last_txn), DATEDIFF(CURDATE(), p.created_on)) AS inactivity_days
FROM plans_plan AS p

/* left join to keep plans with no deposits too */
LEFT JOIN (
        SELECT
            plan_id,
            MAX(created_on) AS last_txn
        FROM savings_savingsaccount
        GROUP BY plan_id
) AS t  ON t.plan_id = p.id

WHERE
      /* active plans only  */
      (p.is_regular_savings = 1 OR p.is_a_fund = 1)

  /*  no inflow for > 365 days */
  AND (
        t.last_txn IS NULL
        OR DATEDIFF(CURDATE(), t.last_txn) > 365
      )

ORDER BY inactivity_days DESC;
