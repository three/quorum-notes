Ubuntu instance, to match docker. Fully upgraded. Need more disk space!

System dependencies
```
sudo apt install -y \
bash-completion libssl-dev krb5-multidev comerr-dev \
python2-dev libpq-dev libproj-dev \
gdal-bin libffi-dev libxml2 libxml2-dev libxslt1-dev \
libxslt1-dev libxslt1.1 libgconf-2-4 libopenblas-dev liblapack-dev \
librsvg2-bin libjpeg-dev make memcached wamerican binutils \
tesseract-ocr imagemagick supervisor xpdf libreoffice-common \
poppler-utils libpulse-dev swig autoconf automake libtool \
pkg-config zsh nodejs postgresql-client postgresql antiword default-jdk \
wkhtmltopdf nginx certbot neovim python3-virtualenv python2-pip-whl \
postgis
```

Create DNS Records to internal
```
dev1.quorumvide.com. A 10.17.7.69
run1.quorumvide.com. A 10.17.7.69
```

Get wildcart certificate
```
sudo certbot --manual --preferred-challenges dns --register-unsafely-without-email --domains '*.quorumvide.com' certonly
```

Nginx proxy
```
server {
	listen 443 ssl default_server;
	ssl_certificate /etc/letsencrypt/live/quorumvide.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/quorumvide.com/privkey.pem;
	location ~ ^/stable-[a-z0-9]+$ {
		proxy_pass http://localhost:8080;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "Upgrade";
	}
	location / { proxy_pass http://localhost:8080; }
}
```

Code server
```
curl -fsSL https://code-server.dev/install.sh | sh -s -- --method standalone
```

Code server config
```
# ~/.config/code-server/config.yaml
bind-addr: 127.0.0.1:8080
auth: none
cert: false
```

Run code server
```
./.local/bin/code-server
```

Create ssh key for github
```
ssh-keygen -t ed25519 -C "dev1.quorumvide.com"
cat ~/.ssh/id_ed25519.pub # Add to Github
```

Clone quorum-site
```
git clone git@github.com:QuorumUS/quorum-site.git
```

Install python2 dependencies, sans pyenchant

Setup postgres,
```
sudo -u postgres psql
could not change directory to "/home/ubuntu/quorum-site": Permission denied
psql (14.5 (Ubuntu 14.5-0ubuntu0.22.04.1))
Type "help" for help.

postgres=# CREATE ROLE root LOGIN SUPERUSER PASSWORD 'dockerizedpostgres';
CREATE ROLE
postgres=# GRANT ALL PRIVILEGES ON DATABASE postgres TO root;
GRANT

=# CREATE ROLE ubuntu LOGIN SUPERUSER PASSWORD 'dockerizedpostgres';
=# GRANT ALL PRIVILEGES ON DATABASE postgres TO ubuntu;
```

Backend tests work!

nvm
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```

Elasticsearch
```
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
sudo apt install elasticsearch
```

Running local server
```sh
cd /
sudo -u postgres dropdb nondockerized_cypress_local_db
sudo -u postgres createdb nondockerized_cypress_local_db
./venv/bin/python manage.py flush --no-input --use_nondockerized_local_db
DOCKER_LOCAL_TESTING_ES=True USE_LOCAL_DB=True ./venv/bin/python manage.py seed_cypress --use_nondockerized_local_db
```