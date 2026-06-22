## Data Quality Notes

- All five tables were successfully loaded into SQLite.
- Row counts matched the dataset documentation:
  - accounts: 500
  - subscriptions: 5,000
  - feature_usage: 25,000
  - support_tickets: 2,000
  - churn_events: 600
- No missing values were found in key account and subscription fields.
- No broken relationships were found between accounts, subscriptions, feature usage, support tickets and churn events.
- Duplicate `usage_id` values were identified in the feature_usage table. Since all feature usage records link correctly to valid subscription IDs, the analysis uses `subscription_id` for joins rather than relying on `usage_id` as a unique identifier.