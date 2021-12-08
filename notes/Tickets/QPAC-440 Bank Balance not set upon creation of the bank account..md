# QPAC-440
https://quorumanalytics.atlassian.net/browse/QPAC-440
https://github.com/QuorumUS/quorum-site/pull/24297

## Migrations

```sql
ALTER TABLE ledger_account
    DROP CONSTRAINT ledger_account_ledger_settings_account_type_uniq;
CREATE UNIQUE INDEX ledger_account_ledger_settings_account_type_uniq
    ON ledger_account (ledger_settings_id, account_type)
    WHERE account_type NOT IN (1001, 1002);
```