# Receipts and Disbursements
## Working Branches
-  `temp/disburse` Disbursements kitchen sink
 
## Kitchen Sink todo
 - [x] Remove memo fields
 - [x] Can't select Batch Name or organization
	 - Actually lots of fields aren't hooked up correctly
 - [x] Text for on/off switches is incorrect
 - [x] Mares says [Date picker isn't configured](https://quorumanalytics.slack.com/archives/CUMJ0EK4J/p1652459578739319?thread_ts=1652459564.440879&cid=CUMJ0EK4J)
	 - It's working for me?
 - [x] Mares wants to allow [editing batches](https://quorumanalytics.slack.com/archives/CUMJ0EK4J/p1652464417321449) (we were going to make this read-only)
	 - See `_refresh_transaction_batch_cache`
	 - Something is up with getting the PieSelect working
 - [x] Lots of spacing issues

## Disbursements Form Pass 1
Work in `temp/disburse-2`

- [x] Disbursement Recipient
	- [x] Missing labels for various Recipient types
- [x] Disbursement type
	- [x] tries to show radio buttons even when there are no options
- [x] Amount, Date and Purpose
	- [x] Transaction Date doesn't initially register today's date
- [x] Payment method
	- [x] must be hidden, even when there are no options
- [ ] Refactoring
	- [ ] styled components should be placed into their own files
	- [ ] components should be moved to more reasonable place
- [ ] Submit
	- [ ] When hitting submit, we should go to the transactions list