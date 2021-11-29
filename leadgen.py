pfizer = Organization.objects.get(id=2460)
action_center = pfizer.action_centers.get()
access_token = action_center.facebook_access_token
def ingest(lead):
    supporter_dict, tag_dict, tracking_info = FacebookLeadAdsHelpers.parse_lead_to_custom_fields_and_supporter_dict(lead, pfizer)
    if not tracking_info:
        return
    return FacebookLeadAdsHelpers.create_or_modify_supporter_from_facebook_lead(supporter_dict, tag_dict, tracking_info, pfizer)

sys.stdout.write('Getting forms...')
res = requests.get("https://graph.facebook.com/v12.0/314499212242/leadgen_forms", params={"access_token": access_token})
instant_forms = res.json()['data']
while res.json().get("paging"):
    res = requests.get("https://graph.facebook.com/v12.0/314499212242/leadgen_forms", params={"access_token": access_token, "after": res.json()["paging"]["cursors"]["after"]})
    sys.stdout.write('.')
    instant_forms.extend(res.json()['data'])
print "done - {} forms".format(len(instant_forms))

leads = []
for form in instant_forms:
    try:
        print "Ingesting {}".format(form['name'])
    except:
        print "Ingesting {}".format(form['id'])
    form_id = form['id']
    res = requests.get("https://graph.facebook.com/v12.0/{}/leads".format(form_id), params={"access_token": access_token})
    leads.extend(res.json()['data'])
    while res.json().get("paging"):
        res = requests.get("https://graph.facebook.com/v12.0/{}/leads".format(form_id), params={"access_token": access_token, "after": res.json()["paging"]["cursors"]["after"]})
        leads.extend(res.json()['data'])
print "done - {} leads".format(len(leads))
