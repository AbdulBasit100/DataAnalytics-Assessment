USE adashi_staging;

SELECT
    p.id AS plan_id,
    sa.owner_id AS user_id,
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
    END AS account_type,
    DATE(MAX(sa.transaction_date)) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, DATE(MAX(sa.transaction_date))) AS days_inactive
FROM savings_savingsaccount sa
JOIN plans_plan p ON sa.plan_id = p.id
WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1
GROUP BY p.id, sa.owner_id, p.is_regular_savings, p.is_a_fund
HAVING days_inactive > 365
-- LIMIT 1000;
