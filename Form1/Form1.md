Planning
--------
https://www.quorum.club/pacinternal/16/filings/prepare_form_one/

Frontned / Backend split

Get functional requirements done before leaving for Christmas Break!! (not happening lol)

1)  Modify component PrepareFormOnePage (PrepareFormOneMainSteps)
    Ensure required fields in correct order
        Might need some extra work to get numbering right -- initialize differently in CSS?
    Factor out Addresse fields -- already done in another component

app/static/frontend/pac/components/PrepareFormOnePage/index.js

- What currently works when submitting the Form 1?
- Save vs Review and File?

**Create PR for just the frontend portion**

(by EOD Friday -- PR by Monday)

2)  Get basic form functionality to testable state
    Remove extaneous requirements for PacFileResource.create_pacfile_and_form
        Why were those added in the first place?
    Form 1 Submits
    Remove Obvious Bugs

3)  Correctly handle data on submit
    Fields need to be matched to FecForm1Submission
        Are fields already the same name as model column???

PacFileResource.create_pacfile_and_form
FecForm1Submission.create_fec_form_1_submission_for_api

**Backend Pull Request**

4)  Testing
    Should Implement Cypress tests

Reduced importantce -- doesn't need to be extensive because we might change this anyway (???)


Potential Questions during Frontend work
----------------------------------------
- There seems not to be a corresponding *Is Report Amendment?* questions on the
  Form3XSubmission model. It seems like this is determined "dynamically" (?) or
  by a foreign key? This needs to be checked on the backend at least.
