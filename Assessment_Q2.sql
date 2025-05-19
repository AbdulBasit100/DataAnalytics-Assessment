USE `adashi_staging`;

WITH transaction_counts AS (
    SELECT
        sa.owner_id,
        COUNT(sa.id) AS total_transactions,
        EXTRACT(YEAR FROM sa.transaction_date) AS year,
        EXTRACT(MONTH FROM sa.transaction_date) AS month
    FROM savings_savingsaccount sa
    WHERE sa.confirmed_amount > 0 -- Only consider confirmed transactions
    GROUP BY sa.owner_id, EXTRACT(YEAR FROM sa.transaction_date), EXTRACT(MONTH FROM sa.transaction_date)
),
monthly_transaction_avg AS (
    SELECT
        owner_id,
        AVG(total_transactions) AS avg_transactions_per_month
    FROM transaction_counts
    GROUP BY owner_id
)
SELECT
    CASE
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        WHEN avg_transactions_per_month <= 2 THEN 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    AVG(avg_transactions_per_month) AS avg_transactions_per_month
FROM monthly_transaction_avg
GROUP BY frequency_category
ORDER BY frequency_category;

