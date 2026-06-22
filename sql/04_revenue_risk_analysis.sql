-- =====================================================
-- Project: SaaS Customer Churn & Revenue-at-Risk Analysis
-- File: 04_revenue_risk_analysis.sql
-- Purpose: Analyse MRR, ARR and revenue-at-risk from churned accounts
-- =====================================================

-- 1. Total MRR and ARR by churn status
SELECT
    churn_flag,
    COUNT(DISTINCT account_id) AS total_accounts,
    ROUND(SUM(mrr_amount), 2) AS total_mrr,
    ROUND(SUM(arr_amount), 2) AS total_arr
FROM subscriptions
GROUP BY churn_flag;


-- 2. Revenue-at-risk from churned subscriptions
SELECT
    COUNT(DISTINCT account_id) AS churned_accounts,
    ROUND(SUM(mrr_amount), 2) AS monthly_revenue_at_risk,
    ROUND(SUM(arr_amount), 2) AS annual_revenue_at_risk
FROM subscriptions
WHERE churn_flag = 1;


-- 3. Revenue-at-risk by plan tier
SELECT
    plan_tier,
    COUNT(DISTINCT account_id) AS churned_accounts,
    ROUND(SUM(mrr_amount), 2) AS monthly_revenue_at_risk,
    ROUND(SUM(arr_amount), 2) AS annual_revenue_at_risk
FROM subscriptions
WHERE churn_flag = 1
GROUP BY plan_tier
ORDER BY annual_revenue_at_risk DESC;


-- 4. Revenue-at-risk by industry
SELECT
    a.industry,
    COUNT(DISTINCT s.account_id) AS churned_accounts,
    ROUND(SUM(s.mrr_amount), 2) AS monthly_revenue_at_risk,
    ROUND(SUM(s.arr_amount), 2) AS annual_revenue_at_risk
FROM subscriptions s
LEFT JOIN accounts a
    ON s.account_id = a.account_id
WHERE s.churn_flag = 1
GROUP BY a.industry
ORDER BY annual_revenue_at_risk DESC;


-- 5. Revenue-at-risk by referral source
SELECT
    a.referral_source,
    COUNT(DISTINCT s.account_id) AS churned_accounts,
    ROUND(SUM(s.mrr_amount), 2) AS monthly_revenue_at_risk,
    ROUND(SUM(s.arr_amount), 2) AS annual_revenue_at_risk
FROM subscriptions s
LEFT JOIN accounts a
    ON s.account_id = a.account_id
WHERE s.churn_flag = 1
GROUP BY a.referral_source
ORDER BY annual_revenue_at_risk DESC;


-- 6. Average MRR by plan tier and churn status
SELECT
    plan_tier,
    churn_flag,
    COUNT(*) AS total_subscriptions,
    ROUND(AVG(mrr_amount), 2) AS average_mrr,
    ROUND(AVG(arr_amount), 2) AS average_arr
FROM subscriptions
GROUP BY plan_tier, churn_flag
ORDER BY plan_tier, churn_flag;


-- 7. High-value churned accounts
SELECT
    s.account_id,
    a.industry,
    a.referral_source,
    s.plan_tier,
    s.seats,
    ROUND(SUM(s.mrr_amount), 2) AS total_mrr_lost,
    ROUND(SUM(s.arr_amount), 2) AS total_arr_lost
FROM subscriptions s
LEFT JOIN accounts a
    ON s.account_id = a.account_id
WHERE s.churn_flag = 1
GROUP BY
    s.account_id,
    a.industry,
    a.referral_source,
    s.plan_tier,
    s.seats
ORDER BY total_arr_lost DESC
LIMIT 10;