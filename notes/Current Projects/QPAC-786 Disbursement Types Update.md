## Disbursement Type Updates

## Cypress run after updating types
```
  (Run Starting)

  ┌────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ Cypress:    8.6.0                                                                              │
  │ Browser:    Electron 93 (headless)                                                             │
  │ Specs:      1 found (pac/disbursement_form_spec.js)                                            │
  │ Searched:   cypress/integration/pac/disbursement_form_spec.js                                  │
  └────────────────────────────────────────────────────────────────────────────────────────────────┘


────────────────────────────────────────────────────────────────────────────────────────────────────

  Running:  pac/disbursement_form_spec.js                                                   (1 of 1)
Browserslist: caniuse-lite is outdated. Please run:
npx browserslist@latest --update-db

Why you should do it regularly:
https://github.com/browserslist/browserslist#browsers-data-updating


  PAC Disbursement Form tests
    New Disbursement
      ✓ Should be able to visit transactions table and click 'Create Disbursement' to open disbursement form (18543ms)
      ✓ Should show validation errors if form is incomplete (13677ms)
      - should prevent you from refunding a transaction if the date of the refund is before the transaction
      - should prevent you from submitting a transaction if you are missing an amount or a transaction method
      ✓ should fail to submit over-contribution to an AffiliatedCommitteeGroup, unless overridden (30920ms)
      (Attempt 1 of 3) should submit bank fee disbursement
      (Attempt 2 of 3) should submit bank fee disbursement
      1) should submit bank fee disbursement
      Public Organization Disbursements
        ✓ should submit contact disbursement via Salaries (8746ms)
        ✓ should submit contact disbursement via Other Disbursements (8577ms)
      Public Organization Disbursements
        - should submit pub org disbursement of type Independent Expenditure to a vendor
        (Attempt 1 of 3) should submit pub org disbursement of type Event Expenses to a vendor
        (Attempt 2 of 3) should submit pub org disbursement of type Event Expenses to a vendor
        2) should submit pub org disbursement of type Event Expenses to a vendor
        ✓ should submit pub org disbursement of type Other Disbursements to a vendor (8651ms)
        ✓ should submit pub org disbursement of type Other Disbursements to an other org (8838ms)
        ✓ should submit pub org disbursement of type Charitable Contributions to an other org (8792ms)
        ✓ should submit pub org disbursement of type Contributions to Other 527 to an other org (8716ms)
        ✓ should submit pub org disbursement of type Other Disbursements to a connected org (8805ms)
        ✓ should submit pub org disbursement of type Other Federal Operating Expenditures to a connected org (8761ms)
      Political Committee Disbursements
        ✓ should show committee information after powersearch (6766ms)
        ✓ should save a disbursement to a committee (8591ms)
        ✓ should save a disbursement to a SSF/Nonconnected Committee as a Contribution to a Federal PAC (8196ms)
        ✓ should save a disbursement to a National Party Committee (8541ms)
        ✓ should save a disbursement to a Party Committee (8948ms)
        - should save a Joint Fundraising Committee disbursement and edit it successfully
    Edit Disbursement
      ✓ should allow a user to edit a disbursement's amount (6661ms)
    Create Refund
      ✓ should create a refund (7564ms)
      ✓ should not be able to create a refund without a description (6861ms)


  19 passing (5m)
  4 pending
  2 failing

  1) PAC Disbursement Form tests
       New Disbursement
         should submit bank fee disbursement:

      AssertionError: expected 400 to equal 201
      + expected - actual

      -400
      +201

      at Context.eval (http://localhost:8000/__cypress/tests?p=cypress/integration/pac/disbursement_form_spec.js:312:38)

  2) PAC Disbursement Form tests
       New Disbursement
         Public Organization Disbursements
           should submit pub org disbursement of type Event Expenses to a vendor:
     CypressError: Timed out retrying after 17000ms: `cy.wait()` timed out waiting `17000ms` for the 1st request to the route: `postNewTransaction`. No request ever occurred.

https://on.cypress.io/wait
      at cypressErr (http://localhost:8000/__cypress/runner/cypress_runner.js:172666:18)
      at Object.errByPath (http://localhost:8000/__cypress/runner/cypress_runner.js:172735:10)
      at checkForXhr (http://localhost:8000/__cypress/runner/cypress_runner.js:159195:92)
      at http://localhost:8000/__cypress/runner/cypress_runner.js:159218:28
      at tryCatcher (http://localhost:8000/__cypress/runner/cypress_runner.js:13212:23)
      at Function.Promise.attempt.Promise.try (http://localhost:8000/__cypress/runner/cypress_runner.js:10486:29)
      at tryFn (http://localhost:8000/__cypress/runner/cypress_runner.js:165332:61)
      at whenStable (http://localhost:8000/__cypress/runner/cypress_runner.js:165371:14)
      at http://localhost:8000/__cypress/runner/cypress_runner.js:164858:18
      at tryCatcher (http://localhost:8000/__cypress/runner/cypress_runner.js:13212:23)
      at Promise._settlePromiseFromHandler (http://localhost:8000/__cypress/runner/cypress_runner.js:11147:31)
      at Promise._settlePromise (http://localhost:8000/__cypress/runner/cypress_runner.js:11204:18)
      at Promise._settlePromise0 (http://localhost:8000/__cypress/runner/cypress_runner.js:11249:10)
      at Promise._settlePromises (http://localhost:8000/__cypress/runner/cypress_runner.js:11329:18)
      at Promise._fulfill (http://localhost:8000/__cypress/runner/cypress_runner.js:11273:18)
      at http://localhost:8000/__cypress/runner/cypress_runner.js:12887:46
  From Your Spec Code:
      at testPubOrgSubmit (http://localhost:8000/__cypress/tests?p=cypress/integration/pac/disbursement_form_spec.js:345:14)
      at Context.eval (http://localhost:8000/__cypress/tests?p=cypress/integration/pac/disbursement_form_spec.js:364:11)




  (Results)

  ┌────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ Tests:        25                                                                               │
  │ Passing:      19                                                                               │
  │ Failing:      2                                                                                │
  │ Pending:      4                                                                                │
  │ Skipped:      0                                                                                │
  │ Screenshots:  6                                                                                │
  │ Video:        true                                                                             │
  │ Duration:     4 minutes, 54 seconds                                                            │
  │ Spec Ran:     pac/disbursement_form_spec.js                                                    │
  └────────────────────────────────────────────────────────────────────────────────────────────────┘


  (Screenshots)

  -  /Users/ericroberts/dev/quorum-site/cypress/screenshots/pac/disbursement_form_spe     (1280x720)
     c.js/PAC Disbursement Form tests -- New Disbursement -- should submit bank fee d
     isbursement (failed).png
  -  /Users/ericroberts/dev/quorum-site/cypress/screenshots/pac/disbursement_form_spe     (1280x720)
     c.js/PAC Disbursement Form tests -- New Disbursement -- should submit bank fee d
     isbursement (failed) (attempt 2).png
  -  /Users/ericroberts/dev/quorum-site/cypress/screenshots/pac/disbursement_form_spe     (1280x720)
     c.js/PAC Disbursement Form tests -- New Disbursement -- should submit bank fee d
     isbursement (failed) (attempt 3).png
  -  /Users/ericroberts/dev/quorum-site/cypress/screenshots/pac/disbursement_form_spe     (1280x720)
     c.js/PAC Disbursement Form tests -- New Disbursement -- Public Organization Disb
     ursements -- should submit pub org disbursement of type Event Expenses to a vend
     or (failed).png
  -  /Users/ericroberts/dev/quorum-site/cypress/screenshots/pac/disbursement_form_spe     (1280x720)
     c.js/PAC Disbursement Form tests -- New Disbursement -- Public Organization Disb
     ursements -- should submit pub org disbursement of type Event Expenses to a vend
     or (failed) (attempt 2).png
  -  /Users/ericroberts/dev/quorum-site/cypress/screenshots/pac/disbursement_form_spe     (1280x720)
     c.js/PAC Disbursement Form tests -- New Disbursement -- Public Organization Disb
     ursements -- should submit pub org disbursement of type Event Expenses to a vend
     or (failed) (attempt 3).png


  (Video)

  -  Started processing:  Compressing to 32 CRF
    Compression progress:  43%
    Compression progress:  88%
  -  Finished processing: /Users/ericroberts/dev/quorum-site/cypress/videos/pac/disbu   (23 seconds)
                          rsement_form_spec.js.mp4


====================================================================================================

  (Run Finished)


       Spec                                              Tests  Passing  Failing  Pending  Skipped
  ┌────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ✖  pac/disbursement_form_spec.js            04:54       25       19        2        4        - │
  └────────────────────────────────────────────────────────────────────────────────────────────────┘
    ✖  1 of 1 failed (100%)                     04:54       25       19        2        4        -
```