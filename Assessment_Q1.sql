/* Q1 - Customers with both funded savings & investment plans */
SELECT
    u.id   AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name)  AS name,
    t.savings_count,
    t.investment_count,
    t.total_deposits / 100   AS total_deposits    -- kobo → ₦aira
FROM users_customuser AS u
JOIN (
    SELECT
        p.owner_id,
        /* count plans of each type */
        SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END)    AS savings_count,
        SUM(CASE WHEN p.is_a_fund        = 1 THEN 1 ELSE 0 END)      AS investment_count,

        /* summing confirmed deposits across all their plans */
        COALESCE((
            SELECT SUM(s.confirmed_amount)
            FROM savings_savingsaccount AS s
            WHERE s.plan_id IN (
                    SELECT id
                    FROM plans_plan
                    WHERE owner_id = p.owner_id
                  )
        ),0)  AS total_deposits

    FROM plans_plan AS p
    GROUP BY p.owner_id
) AS t  ON t.owner_id = u.id

/* keeping only customers with ≥1 of each product */
WHERE t.savings_count    >= 1
  AND t.investment_count >= 1

ORDER BY t.total_deposits DESC;