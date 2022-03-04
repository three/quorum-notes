# QPAC-548 Bulk Upload Emails

## Todo
 - [ ] Test the existing functionality

## Scripts

```python
BulkUploadFile.objects.unsafe_filter(id=55886).update(status=2)
for bu in BulkUploadFile.objects.unsafe_filter(upload_type=12, status=2):
  management.call_command(
    "parse",
    "individual_contributions",
    bulk_upload_file=bu,
  )
```

## Notes
What's happening now is on "successful" completion of the BulkUpload, we call `ConfirmationEmail.create_bulk_upload_confirmation_email`, which creates a confirmation email `<EmailTemplate: #11389>` with template `{{cf_e_bulk_upload_conf_email_content}}`. This eventually gets filled with `BulkUploadFile.confirmation_email_results` (a property), which returns,

```python
        results = [
            ["Total Transactions", self.num_created + self.num_updated + self.num_failed_rows],
            ["Transactions Uploaded", self.num_created],
            ["Transactions Failed", self.num_failed_rows],
            ["Total Transaction Value", convert_long_to_currency(total_amount)],
        ]
```

relevant ff: `ff_bulk_upload_conf_email`
Email created in `ConfirmationEmail.create_bulk_upload_confirmation_email`