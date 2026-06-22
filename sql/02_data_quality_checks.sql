-- =====================================================
-- Project: SaaS Customer Churn & Revenue-at-Risk Analysis
-- File: 02_data_quality_checks.sql
-- Purpose: Check row counts, nulls, duplicates and table relationships
-- =====================================================

-- 1. Row count checks
SELECT 'accounts' AS table_name, COUNT(*) AS row_count FROM accounts
UNION ALL
SELECT 'subscriptions', COUNT(*) FROM subscriptions
UNION ALL
SELECT 'feature_usage', COUNT(*) FROM feature_usage
UNION ALL
SELECT 'support_tickets', COUNT(*) FROM support_tickets
UNION ALL
SELECT 'churn_events', COUNT(*) FROM churn_events;

-- 2. Duplicate primary key checks
SELECT account_id, COUNT(*) AS duplicate_count
FROM accounts
GROUP BY account_id
HAVING COUNT(*) > 1;

SELECT subscription_id, COUNT(*) AS duplicate_count
FROM subscriptions
GROUP BY subscription_id
HAVING COUNT(*) > 1;

SELECT usage_id, COUNT(*) AS duplicate_count
FROM feature_usage
GROUP BY usage_id
HAVING COUNT(*) > 1;

SELECT ticket_id, COUNT(*) AS duplicate_count
FROM support_tickets
GROUP BY ticket_id
HAVING COUNT(*) > 1;

SELECT churn_event_id, COUNT(*) AS duplicate_count
FROM churn_events
GROUP BY churn_event_id
HAVING COUNT(*) > 1;

-- 3. Missing value checks in important fields
SELECT 
    SUM(CASE WHEN account_id IS NULL THEN 1 ELSE 0 END) AS missing_account_id,
    SUM(CASE WHEN industry IS NULL THEN 1 ELSE 0 END) AS missing_industry,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS missing_country,
    SUM(CASE WHEN plan_tier IS NULL THEN 1 ELSE 0 END) AS missing_plan_tier,
    SUM(CASE WHEN churn_flag IS NULL THEN 1 ELSE 0 END) AS missing_churn_flag
FROM accounts;

SELECT 
    SUM(CASE WHEN subscription_id IS NULL THEN 1 ELSE 0 END) AS missing_subscription_id,
    SUM(CASE WHEN account_id IS NULL THEN 1 ELSE 0 END) AS missing_account_id,
    SUM(CASE WHEN mrr_amount IS NULL THEN 1 ELSE 0 END) AS missing_mrr,
    SUM(CASE WHEN arr_amount IS NULL THEN 1 ELSE 0 END) AS missing_arr,
    SUM(CASE WHEN churn_flag IS NULL THEN 1 ELSE 0 END) AS missing_churn_flag
FROM subscriptions;

-- 4. Relationship checks: subscriptions without matching accounts
SELECT COUNT(*) AS subscriptions_without_account
FROM subscriptions s
LEFT JOIN accounts a
    ON s.account_id = a.account_id
WHERE a.account_id IS NULL;

-- 5. Relationship checks: feature usage without matching subscriptions
SELECT COUNT(*) AS usage_without_subscription
FROM feature_usage f
LEFT JOIN subscriptions s
    ON f.subscription_id = s.subscription_id
WHERE s.subscription_id IS NULL;

-- 6. Relationship checks: support tickets without matching accounts
SELECT COUNT(*) AS tickets_without_account
FROM support_tickets t
LEFT JOIN accounts a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;

-- 7. Relationship checks: churn events without matching accounts
SELECT COUNT(*) AS churn_events_without_account
FROM churn_events c
LEFT JOIN accounts a
    ON c.account_id = a.account_id
WHERE a.account_id IS NULL;