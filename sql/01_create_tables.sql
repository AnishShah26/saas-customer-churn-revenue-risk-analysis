-- =====================================================
-- Project: SaaS Customer Churn & Revenue-at-Risk Analysis
-- File: 01_create_tables.sql
-- Purpose: Create database schema for RavenStack SaaS dataset
-- =====================================================

DROP TABLE IF EXISTS churn_events;
DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS feature_usage;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
    account_id TEXT PRIMARY KEY,
    account_name TEXT,
    industry TEXT,
    country TEXT,
    signup_date DATE,
    referral_source TEXT,
    plan_tier TEXT,
    seats INTEGER,
    is_trial BOOLEAN,
    churn_flag BOOLEAN
);

CREATE TABLE subscriptions (
    subscription_id TEXT PRIMARY KEY,
    account_id TEXT,
    start_date DATE,
    end_date DATE,
    plan_tier TEXT,
    seats INTEGER,
    mrr_amount REAL,
    arr_amount REAL,
    is_trial BOOLEAN,
    upgrade_flag BOOLEAN,
    downgrade_flag BOOLEAN,
    churn_flag BOOLEAN,
    billing_frequency TEXT,
    auto_renew_flag BOOLEAN,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE feature_usage (
    usage_id TEXT PRIMARY KEY,
    subscription_id TEXT,
    usage_date DATE,
    feature_name TEXT,
    usage_count INTEGER,
    usage_duration_secs INTEGER,
    error_count INTEGER,
    is_beta_feature BOOLEAN,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

CREATE TABLE support_tickets (
    ticket_id TEXT PRIMARY KEY,
    account_id TEXT,
    submitted_at DATETIME,
    closed_at DATETIME,
    resolution_time_hours REAL,
    priority TEXT,
    first_response_time_minutes INTEGER,
    satisfaction_score REAL,
    escalation_flag BOOLEAN,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE churn_events (
    churn_event_id TEXT PRIMARY KEY,
    account_id TEXT,
    churn_date DATE,
    reason_code TEXT,
    refund_amount_usd REAL,
    preceding_upgrade_flag BOOLEAN,
    preceding_downgrade_flag BOOLEAN,
    is_reactivation BOOLEAN,
    feedback_text TEXT,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);