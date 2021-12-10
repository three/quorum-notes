# Debugging Grassroots Domains

Normally you just do subdomain.quorum.club, for instance https://quorumdev.quorum.us/, but this doesn't work with full domains.

First, update the nginx config to overrite the Host header:

```nginx
#proxy_set_header Host $host;
proxy_set_header Host www.recyclinginfrastructurenow.com;
```

Then we need to make `SubdomainProcessor` think `settings.DEBUG` is false *and* allow that domain.

```diff
diff --git a/quorum/middleware.py b/quorum/middleware.py
index a32217d56ac..cbe3d0d4939 100644
--- a/quorum/middleware.py
+++ b/quorum/middleware.py
@@ -372,7 +372,7 @@ class SubdomainMiddleware:
         # out the URL to see if there's a subdomain in the runserver. This can
         # be achieved by modifying /etc/hosts/.
         if (
-            (settings.DEBUG and not settings.STAGING and settings.SUBDOMAIN)
+            (settings.DEBUG and not settings.STAGING and settings.SUBDOMAIN and False)
             or (
                 settings.TESTS_IN_PROGRESS and
                 not settings.RUNNING_E2E_TESTS_IN_CONTAINER and
@@ -443,7 +443,7 @@ class SubdomainMiddleware:
 
                 # if we're not hosted on a quorum root domain, we put the full domain in the domain field
                 # of ActionCenterSettings objects and therefore we need to add it back into the subdomain
-                if root_domain not in ["quorum.us", "quorum.club"] and not settings.DEBUG:
+                if root_domain not in ["quorum.us", "quorum.club"]:
                     if subdomain:
                         subdomain += "." + root_domain
                     else:
diff --git a/quorum/settings/development_settings.py b/quorum/settings/development_settings.py
index d960ac12a49..182368564ef 100755
--- a/quorum/settings/development_settings.py
+++ b/quorum/settings/development_settings.py
@@ -206,6 +206,7 @@ ALLOWED_HOSTS = [
 
     # we are whitelisting every quorum.club on development.
     ".quorum.club",
+    "*",
 ]
 USE_PROD_DATABASE = False
 USE_PROD_AWS = False

```