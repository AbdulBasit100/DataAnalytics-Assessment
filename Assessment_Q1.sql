USE `adashi_staging`;

SELECT
    u.id AS user_id,
    u.username,
    SUM(sa.confirmed_amount) AS total_deposits,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN sa.id END) AS savings_plan_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN sa.id END) AS investment_plan_count
FROM users_customuser u
JOIN savings_savingsaccount sa ON sa.owner_id = u.id
JOIN plans_plan p ON sa.plan_id = p.id
WHERE 
    sa.confirmed_amount > 0
    AND (
        p.is_regular_savings = 1 -- Savings plan condition
        OR p.is_a_fund = 1       -- Investment plan condition
    )
GROUP BY u.id, u.username
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN sa.id END) > 0
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN sa.id END) > 0
ORDER BY total_deposits DESC;

