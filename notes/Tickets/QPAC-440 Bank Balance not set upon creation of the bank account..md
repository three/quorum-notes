# QPAC-440
https://quorumanalytics.atlassian.net/browse/QPAC-440
https://github.com/QuorumUS/quorum-site/pull/24297

## Migrations

```sql
ALTER TABLE ledger_account
    DROP CONSTRAINT ledger_account_ledger_settings_account_type_uniq;
```