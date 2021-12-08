*This document lives at https://github.com/QuorumUS/quorum-site/wiki/Grassroots-Lead-Ads-Integration*

# Grassroots-Lead Ads integration

## Background Information

### What are Lead Ads?

[From Facebook](https://www.facebook.com/business/help/1481110642181372):
> Lead ads allow you to find people who may be interested in your products or
> services and collect information from them. Using an Instant Form, you can
> collect contact information such as name, email address, phone number and
> more. These forms also let you include custom questions to help you understand
> your potential customers and reach your business goals.
>
> You can use lead ads to:
>  * Identify potential customers for your business
>  * Collect subscriber information for your company newsletter
>  * Encourage downloads of white papers or brochures
>  * Understand the interests and behaviors of potential clients
>  * Get people to enroll in your programs
>  * You can see an example in action on this page.

This document will primarily focus on Facebook lead ads. Since Facebook (or Meta
I guess) shares an ad system with Instagram Facebook lead ads are fully
compatible with Instagram ads and work the same way. We also support leads view
Zapier, which supports more types of lead ads but isn't as well integrated.

Think of it as an advertisement linking to a form, except there's a few
advantages:
 * The form is native to Facebook so when you open it on your phone it's fast
   and matches tha app's interface
 * Because the form appears within Facebook, certain fields can be filled out
   automatically if Facebook has that information (for instance, Facebook
   usually has your name, email, etc)
 * Overall less friction than loading a separate website, especially on mobile

### How Quorum integrates with Facebook leads

Most of what our lead ads integration forms does could be done manually but we
add value in a few ways:

 * We create instant forms automatically based on registration forms. Note we do
   not create the advertisements automatically. When users create a lead ad
   they’ll have the option to select which instant form they want.
 * We set up a webhook so any time an instant form we generate is filled out we
   automatically “ingest” it, usually within seconds of the user submitting.
 * The instant forms we generate are either associated with a Campaign or a
   Registration Page. It acts as if they registered and submitted a campaign.
 * Only Write a Letter and Write White House campaigns are supported, and only
   if editing of the campaign message is disabled. We do not collect information
   from the form specific to the campaign, only for the registration page.

## The life of a lead

To learn how to debug leads let's start by walking through the process of
following the life of a single lead.

This is a follow-along section, so get a dev server running.

### The Graph and Marketing API

Facebook's Graph API is just the name of Facebook's API for anything
Facebook/Meta related and the Marketing API is just a subset of the Graph API.
It's REST and pretty easy to use (although often lacking documentation) and the
same API we scrape Facebook with.

There's only a few objects in the Graph API we care about:
 * A Facebook [User][fbuser] for obvious reasons
 * A Facebook [Page][fbpage], since Facebook considers a Page to be something
   similar to an organization as far as advertisements go. This means lead forms
   are attached to a specific page and other advertising objects are contained
   within the scope of a page.

[fbuser]: https://developers.facebook.com/docs/graph-api/reference/user/
[fbpage]: https://developers.facebook.com/docs/graph-api/reference/page/

## Technical Workflow

### Connecting to Facebook

Before the lead can exist we need to create the leadgen forms on the page. Go to https://www.quorum.us/action_centers/1147/settings/ and in the *Facebook Lead Ads* section Disconnect if connecte then click Connect and select the Facebook page you're trying to connect.

Within the store this button is now associated with the following value:

```js
store.getState().actionCenterSettings.getIn(["actionCenterSettings", "facebook_connection"]).toJS()

{
  "pageName": "Test Page",
  "pageId": "102997758242346",
  "userAccessToken": "EAALWT1A78IIBANDTGAq4ZAcIE3SJL8eSAI2YrdIWDezOTsQYrZADJMvbLO5axXGe0sIZBFPtC5EIzRPkTTh9LyoCeSsveXFKbM9MmRe1slggRFxXA1ZAiWn1Wg0QU7A77D6bVjsoCgXXFhGUEO3Jsr8VdOoeU8hySGHZCEi0UmU6yDyFKvZBJD3rZA8FshZCFuOeuDsBmOd3DgbTbOpe4jh5se8fACAG602wyYIZAlerNjQZDZD"
}
```

When you click Save this gets sent to the server, where the `userAccessToken` gets put in `action_center.facebook_user_token`, and is cleared from the `facebook_access_token` object. Note this is a [User Token][usertoken], although when you connect via the popup you'll have given the user token access to some number of Facebook pages.

[usertoken]: https://developers.facebook.com/docs/facebook-login/access-tokens/#usertokens

If everything here was successful the action center should have moved from `facebook_status=FacebookConnectionStatus.unconnected` to `facebook_status=FacebookConnectionStatus.has_user_access_token`.

#### Failure Mode: Not clicking Save Settings

The most common failure mode at this step occurs if the user connects then doesn't click Save Settings. The Connect to Facebook button is just a form field, so it needs ot be saved just like any other form element. Some people "Connect" and then immediately navigate away from the page.

#### Failure Mode: Invalid Permissions

If you look at `app/static/frontend/action-center-settings/components/ConnectToFacebookButton.jsx` we filter out any pages that don't have the `ADVERTISE` [task][fbtask]. Basically if the user doesn't have permission to work with advertisements the access token we get from them won't be able to either.

[fbtask]: https://www.facebook.com/business/help/1053717031486355

This means a user might try to connect a page but not see the page they're trying to connect.

### Getting the Page Access Token

This step occurs in `FacebookLeadAdsCron`, which runs every few minutes.

First we need to convert out User Token to a [Page Token][pagetoken] and subscribe to leads which happens in the `FacebookLeadAdsCron.connect_pages_with_user_access_token` function. Once we have the user access token we also subscribe to leads in this stage. This is just a simple API call that tells Facebook we want to recieve a webhook event for all leads created on that particular Facebook page.

[pagetoken]: https://developers.facebook.com/docs/facebook-login/access-tokens/#pagetokens

#### Failure Mode: Bad Permissions

Even though we try to prevent connections to pages we don't have the proper permissions sometimes we can't get the permissions for reasons we can't detect, and this will show up in this stage. If this happens you'll get an error that looks something like,

```
FacebookAPIException (AYf5oWTRKxDeIIweXJrRRYJ): The user must be an administrator, editor, or moderator of the page in order to impersonate it. If the page business requires Two Factor Authentication, the user also needs to enable Two Factor Authentication. while attempting to POST [https://graph.facebook.com/v8.0/294419022271004?access_token=REDACTED](https://graph.facebook.com/v8.0/294419022271004?access_token=REDACTED). Request Body: status=ARCHIVED  Full Response: {"error":{"message":"The user must be an administrator, editor, or moderator of the page in order to impersonate it. If the page business requires Two Factor Authentication, the user also needs to enable Two Factor Authentication.","type":"OAuthException","code":190,"error_subcode":492,"fbtrace_id":"AYf5oWTRKxDeIIweXJrRRYJ"}}
```

In this particular case the user changed their password so we're getting this error at a different stage in the workflow, trying to archive an old page. But the error message (prior to the phrase "while attempting to") will be similar. (Unfortunately changing your password can affect accesss tokens you've authorized and we don't have a way to test this.)

This first place this error can occur is in `subscribe_to_leads` but it can occur anywhere hereafter.

### Creating the leadgen forms

This occurs in `generate_all_lead_forms_for_reg_forms` and `generate_all_lead_forms_for_campaigns` which are functions on the cron. A lot of the business logic is in converting our grassroots forms to the format Facebook accepts for creating lead forms.

These forms will show up in https://business.facebook.com/latest/instant_forms/forms.

#### Failure Mode: Missing Fields and Forms

Not all fields in Grassroots are supported in Facebook leadgen forms, particularly select many fields are not allowed. When generating registration forms these fields are skipped. This can be confusing.

For campaigns not all types of campaigns are allowed. Only Write a Letter or Write to Whitehouse campaigns are allowed and only if the campaign does not allow editing. The actual form fields are copied directly over from the default registration page of the campaign. We skip over campaigns that don't meet these requirements.

### Creating an Advertisement and Getting Leads

This is the one part of the workflow Quorum has no part in. Before any lead object is created the client needs to create an advertisement, specifically of type Lead Generation, and attach our lead form to the advertisement. The leadgen form is a completely sepearte object than the ad and the ad creative (the part of the ad that the user sees when browsing Facebook).

Once the ad is deployed, targeted users will (hopefully) click on it and fill out the form generating a lead.

You can use the [lead ad testing tool][leadtester] to generate a lead without having to generate a test advertisement. This tool is pretty vital to testing since we can't deploy test advertisements.

[leadtester]: https://developers.facebook.com/tools/lead-ads-testing

### Ingesting the Lead

Anytime a lead is created Faebook will notify https://www.quorum.us/facebook_webhook/ by sending a post request.

```
In [4]: UserRequest.objects.filter(path='/facebook_webhook/').order_by('-created').first().payload_json
Out[4]:
{u'entry': [{u'changes': [{u'field': u'leadgen',
     u'value': {u'ad_id': u'23848792890420064',
      u'adgroup_id': u'23848792890420064',
      u'created_time': 1638199201,
      u'form_id': u'391649062614688',
      u'leadgen_id': u'417033750093994',
      u'page_id': u'113891694102'}}],
   u'id': u'113891694102',
   u'time': 1638199231}],
 u'object': u'page'}
```

Let's grab the contents of this particular lead,

```
In [5]: ActionCenterSettings.objects.filter(facebook_page_id='113891694102')
Out[5]: <QuerySet [<ActionCenterSettings: #1340 | Energy Citizens State Campaigns >, <ActionCenterSettings: #1337 | Energy Citizens - Marginal>, <ActionCenterSettings: #1421 | Communications Team Action Center>, <ActionCenterSettings: #1332 | State Comms Action Center>, <ActionCenterSettings: #1418 | Energy Trades>, <ActionCenterSettings: #1338 | Vets for Energy>, <ActionCenterSettings: #1339 | Energy Citizens - National >]>

In [7]: _5.values_list('facebook_access_token').distinct()
Out[7]: <QuerySet [(u'EAALWT1A78IIBANDTGAq4ZAcIE3SJL8eSAI2YrdIWDezOTsQYrZADJMvbLO5axXGe0sIZBFPtC5EIzRPkTTh9LyoCeSsveXFKbM9MmRe1slggRFxXA1ZAiWn1Wg0QU7A77D6bVjsoCgXXFhGUEO3Jsr8VdOoeU8hySGHZCEi0UmU6yDyFKvZBJD3rZA8FshZCFuOeuDsBmOd3DgbTbOpe4jh5se8fACAG602wyYIZAlerNjQZDZD',)]> # This is representative of what an access token looks like but isn't API's actual token

In [8]: requests.get('https://graph.facebook.com/v11.0/417033750093994', params={"access_token": _7[0][0]})
Out[8]: <Response [200]>

In [9]: _8.json()
Out[9]:
{u'created_time': u'2021-11-29T15:20:01+0000',
 u'field_data': [{u'name': u'quorum_ingest',
   u'values': [u'reg:3978,campaign:35302']},
  {u'name': u'firstname', u'values': [u'redacted']},
  {u'name': u'lastname', u'values': [u'redacted']},
  {u'name': u'email', u'values': [u'redacted@example.com']},
  {u'name': u'input_address', u'values': [u'1234 Redacted Ave.']},
  {u'name': u'zip_code', u'values': [u'00000']}],
 u'id': u'417033750093994'}
```

This is a real lead but the important parts are redacted.

This lead gets parsed as follows:

 * Since we have a `quorum_ingest` value this is fit for ingestion. Leads without this value are ignored.
 * The `firstname`, `lastname` and `email` fields are parsed as you would expect.
 * Address becomes `1234 Redacted Ave. 00000`, and this is what gets geocoded.
 * We know this corresponds to `<GrassrootsRegistrationPage: GrassrootsRegistrationPage #3978 | Pennsylvanians Should Decide What Cars Pennsylvanians Can Buy>`  so we create a GrassrootsSupporterAction for registering and attach that reg page.
 * We know this corresponds to `<Campaign: Campaign #35302 | Write a Letter to Say Pennsylvanians Should Decide What Cars Pennsylvanians Can Buy>` so we create another GrassrootsSupporterAction, generating the message to send to the various Pennsylvania reps and all the other data we need.

#### Failure Mode: No address

Facebook splits it's address fields into Street Address, City, State, Province, Country, Post Code and Zip Code while encouraging forms to be as short as possible. We try to geocode from the zip code and street address, which is usually fine.

For that and various other reasons, however, it is possible an address doesn't geocode. In this case we just save without the address.

#### Failure Mode: Duplicate Forms

When we create the form we attach the `quorum_ingest` metadata. Sometimes a client will try to duplicate a form within the Facebook UI which *usually* works but the GUI is finicky and if they do anything to reset this metadata we won't ingest the form properly.

This is exasperated with custom fields. For these we attach metadata that changes the name of the field. Facebook's ui makes these very easy to clear.

For this reason this feature isn't supported.

### Archiving Old Forms

We can't edit lead forms once we create them, so instead we archive them. Archived forms can still be used in existing ads but can't be attached to new ones. The updated form then just gets created anew.

#### Failure Mode: This is broken

I believe this feature is actually broken since the v11.0 API upgrade. Users have to manually archive old forms for now.