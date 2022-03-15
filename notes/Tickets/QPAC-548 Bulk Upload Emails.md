# QPAC-548 Bulk Upload Emails

## Todo
 - [x] Initiate an example of the email, as it currently sends now
 - [x] Figure out how to modify email contents
 - [x] Figure out how to add an attachment to a `ConfirmationEmail`
 - [ ] Figure out how to embellish the CSV

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

 - Sending the confirmation emails is ultimately done in `ConfirmationEmailSender.send_confirmation_emails`, which batches them into `_prepare_and_send_batch_confirmation_emails`. The bulk upload emails shouldn't be btached and should be handled separately.
 - We already generate the attachments list, albeit empty, in `ConfirmationEmailSend._get_transmission_dict`. The object will look like, `{'name': 'Hello World', 'type': 'text/html; charset="UTF-8"', 'data': base64.b64encode(attachment_date)}`
 - Probably need an array of attachments on the `ConfirmationEmail` object. The data will come from S3.
   

## Test Case
On dev db: `Bulk Upload Id: 60135`

To run parse,

```python
bu = BulkUploadFile.objects.unsafe_get(id=60137)
bu.status = BulkUploadStatus.queued
bu.save(update_fields=['status'])
management.call_command(
    "parse",
    "individual_contributions",
    bulk_upload_file=bu
)
```

To reset,

```python
from app.custom_data.crons import *

bu = BulkUploadFile.objects.unsafe_get(id=60135)
bu.status = BulkUploadStatus.queued
bu.save()
```

To send confirmation emails,

```python
# Need to remove selenium imports from vote_campaign.py
from app.emails.crons import *
ConfirmationEmailCronJob.run_do()
```

or
```python
from app.emails.crons import *
emails = ConfirmationEmail.objects.unsafe_filter(id=1787173)
ConfirmationEmailSender().send_confirmation_emails(
    unprocessed_bulk_upload_emails=emails
)
```

## Migrations

```sql
BEGIN;

CREATE TABLE userdata_confirmationemailattachment (
    "id" serial NOT NULL PRIMARY KEY,
    "created" timestamptz NOT NULL DEFAULT now(),
    "updated" timestamptz NOT NULL DEFAULT now(),
    "confirmation_email_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "mime_type" TEXT NOT NULL,
    "s3_bucket" TEXT NOT NULL,
    "s3_path" TEXT NOT NULL
);

ALTER TABLE userdata_confirmationemailattachment OWNER TO quorum_user;
GRANT INSERT, UPDATE, DELETE, SELECT
    ON TABLE userdata_confirmationemailattachment
    TO production;

ALTER TABLE userdata_confirmationemailattachment
    ADD CONSTRAINT userdata_confirmationemailattachment__confirmation_email__fk
    FOREIGN KEY ("confirmation_email_id")
    REFERENCES "userdata_confirmationemail" (id);

COMMIT;
```