USE adashi_staging;

SELECT
    u.id AS customer_id,
    CONCAT(
        COALESCE(u.first_name, ''), 
        CASE WHEN u.first_name IS NOT NULL AND u.last_name IS NOT NULL THEN ' ' ELSE '' END,
        COALESCE(u.last_name, '')
    ) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
    COUNT(sa.id) AS total_transactions,
    CASE
        WHEN TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) = 0 THEN 0
        ELSE
            (COUNT(sa.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE)) * 12 * (AVG(sa.confirmed_amount) * 0.001)
    END AS estimated_clv
FROM users_customuser u
LEFT JOIN savings_savingsaccount sa 
    ON sa.owner_id = u.id AND sa.confirmed_amount > 0
GROUP BY u.id, u.first_name, u.last_name, u.date_joined
ORDER BY estimated_clv DESC
-- LIMIT 1000;
