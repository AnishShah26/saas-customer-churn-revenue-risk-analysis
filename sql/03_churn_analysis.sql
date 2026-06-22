-- =====================================================
-- Project: SaaS Customer Churn & Revenue-at-Risk Analysis
-- File: 03_churn_analysis.sql
-- Purpose: Analyse churn rate, customer segments and churn drivers
-- =====================================================

-- 1. Overall customer churn rate
SELECT
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM accounts;


-- 2. Churn rate by plan tier
SELECT
    plan_tier,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM accounts
GROUP BY plan_tier
ORDER BY churn_rate_percentage DESC;


-- 3. Churn rate by industry
SELECT
    industry,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM accounts
GROUP BY industry
ORDER BY churn_rate_percentage DESC;


-- 4. Churn rate by referral source
SELECT
    referral_source,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM accounts
GROUP BY referral_source
ORDER BY churn_rate_percentage DESC;


-- 5. Churn rate by seat size group
SELECT
    CASE
        WHEN seats BETWEEN 1 AND 5 THEN '1-5 seats'
        WHEN seats BETWEEN 6 AND 20 THEN '6-20 seats'
        WHEN seats BETWEEN 21 AND 50 THEN '21-50 seats'
        ELSE '50+ seats'
    END AS seat_size_group,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        100.0 * SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM accounts
GROUP BY seat_size_group
ORDER BY churn_rate_percentage DESC;


-- 6. Top churn reasons
SELECT
    reason_code,
    COUNT(*) AS churn_events,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM churn_events),
        2
    ) AS percentage_of_churn_events
FROM churn_events
GROUP BY reason_code
ORDER BY churn_events DESC;


-- 7. Churn reasons by plan tier
SELECT
    a.plan_tier,
    c.reason_code,
    COUNT(*) AS churn_events
FROM churn_events c
LEFT JOIN accounts a
    ON c.account_id = a.account_id
GROUP BY a.plan_tier, c.reason_code
ORDER BY a.plan_tier, churn_events DESC;