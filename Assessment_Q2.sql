/* Q2 Transaction Frequency Analysis */
-- Create a temporary table combining both deposits and withdrawals as transactions
CREATE TEMPORARY TABLE tmp_all_transactions AS
SELECT owner_id, created_on FROM savings_savingsaccount
UNION ALL
SELECT owner_id, created_on FROM withdrawals_withdrawal;

-- Calculating total transactions per month per customer from combined transactions
CREATE TEMPORARY TABLE tmp_avg_transaction_per_month AS
SELECT
    owner_id,
    COUNT(*) AS total_txn,
    TIMESTAMPDIFF(MONTH, MIN(created_on), MAX(created_on)) + 1 AS months_active,
    COUNT(*) / (TIMESTAMPDIFF(MONTH, MIN(created_on), MAX(created_on)) + 1) AS avg_txn_pm
FROM tmp_all_transactions
GROUP BY owner_id;

-- Categorizing customers based on average transactions per month
SELECT
    CASE
        WHEN avg_txn_pm >= 10 THEN 'High Frequency'
        WHEN avg_txn_pm >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_pm), 1) AS avg_transactions_per_month
FROM tmp_avg_transaction_per_month
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
