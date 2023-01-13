# Ngrok-like Public Port Forward
This is used if you want to forward your local Quorum instance (or another service) to the public web to, for instance, test on mobile.

## Basic Command

Basic command is,

```sh
ssh -R 9999:localhost:80 eric@selfhost1.threedot14.com
```

Then go to https://fwd.webservicetest.online/.

## If you need to access bundles
 The above works fine if it's just a webhook, or otherwise only needs to access the Django server. Unfortunately if you go to the address expecting to load Quorum or Grassroots you'll fail to find the bundle, which is loaded from `http://localhost:8001` by default.
 
 To fix this, have nginx pass bundle requests to the webpack dev server (see below), and set the pubic path to be realtive.
 
```diff
--- a/webpack/webpack.dev.babel.js
+++ b/webpack/webpack.dev.babel.js
@@ -24,7 +24,7 @@ const config = {
     output: {
         path: path.resolve('app/static/bundles/'),
         filename: '[name].js',
-        publicPath: `${devServer}:${port}/app/static/bundles/`,
+        publicPath: `/app/static/bundles/`,
         chunkFilename: '[name].bundle.js',
     },
     plugins: [
```

## Nginx and DNS Configs

On `selfhost1.threedot14.com`, we have the following nginx setup:

```nginx
server {
	root /var/www/html/feed;
	server_name fwd.webservicetest.online;

	location / {
		proxy_pass http://localhost:9999;
	}

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/fwd.webservicetest.online/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/fwd.webservicetest.online/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}
```

Additionally we have a CNAME record pointing `fwd.webservicetest.online` to `selfhost1.threedot14.com`.

The result is any HTTP service on port 80 is proxied (including HTTP) to the public web.

```
server {
    listen 80;
    server_name fwd.webservicetest.online;

    location /app/static/bundles {
        proxy_pass http://127.0.0.1:8001;
        proxy_pass_request_headers on;
    }

    location / {
				# Host will generally be set to X.quorum.club
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_pass_request_headers on;
        proxy_pass http://127.0.0.1:8000;
    }
}
```