from app.grassroots.classes import FacebookAPIException, FacebookLeadAdsHelpers

action_center = ActionCenterSettings.objects.get(id=1339)

org = action_center.organization_ng
access_token = action_center.facebook_access_token
appsecret_proof = FacebookLeadAdsHelpers.calculate_appsecret_proof(access_token)

facebook_page_id = action_center.facebook_page_id

sys.stdout.write('Getting forms...')
res = requests.get(
    "https://graph.facebook.com/v8.0/{}/leadgen_forms".format(facebook_page_id),
    params={"access_token": access_token, "appsecret_proof": appsecret_proof}
)
FacebookAPIException.raise_if_error(res)
instant_forms = res.json()['data']
while res.json().get("paging"):
    res = requests.get(
        "https://graph.facebook.com/v8.0/{}/leadgen_forms".format(facebook_page_id),
        params={"access_token": access_token, "after": res.json()["paging"]["cursors"]["after"], "appsecret_proof": appsecret_proof}
    )
    FacebookAPIException.raise_if_error(res)
    sys.stdout.write('.')
    instant_forms.extend(res.json()['data'])
print "done - {} forms".format(len(instant_forms))

leads = []
for form in instant_forms:
    try:
        print "Retrieving {}".format(form['name'])
    except:
        print "Retrieving {}".format(form['id'])
    form_id = form['id']
    res = requests.get(
        "https://graph.facebook.com/v8.0/{}/leads".format(form_id),
        params={"access_token": access_token, "appsecret_proof": appsecret_proof}
    )
    FacebookAPIException.raise_if_error(res)
    print res.json()
    leads.extend(res.json()['data'])
    while res.json().get("paging"):
        res = requests.get(
            "https://graph.facebook.com/v8.0/{}/leads".format(form_id),
            params={"access_token": access_token, "after": res.json()["paging"]["cursors"]["after"], "appsecret_proof": appsecret_proof}
        )
        FacebookAPIException.raise_if_error(res)
        print res.json()
        leads.extend(res.json()['data'])
print "done - {} leads".format(len(leads))


def ingest(lead):
    supporter_dict, tag_dict, tracking_info = FacebookLeadAdsHelpers.parse_lead_to_custom_fields_and_supporter_dict(lead, org)
    if not tracking_info:
        print "Lead does not have ingestion data -- ignoring"
        return
    supporter = Supporter.objects.filter(organization=org, email=supporter_dict["email"]).first()
    if supporter is not None:
        print "Supporter %r exists -- skipping ingestion" % supporter
        return
    supporter = FacebookLeadAdsHelpers.create_or_modify_supporter_from_facebook_lead(supporter_dict, tag_dict, tracking_info, org)
    print "Created supporter %r" % supporter
    return supporter
