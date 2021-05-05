# Eric's Quorum Config

## Setting up Quorum

As a prereq you need https://www.macports.org/. If you haven't used macports
it's simialar to brew but is designed more like Linux package managers and,
importantly, has better support of older software (ie python2). Note macports
claims it doesn't play well with brew also installed, but I haven't had
problems.

Here's the packages you need to `sudo port install`:

```
# Gives us cli tools we need
git
git-crypt
gnupg2
curl

# Optional services
nginx
dnsmasq

# Python3 tools
python3
py39-mypy
py39-virtualenv

# Python2 and libraries that have system dependencies
python27
py27-gdal
py27-enchant
py27-pip
```

The commands that result from this will be stored in `/opt/local/bin`.

Extract quorum-site somewhere, you'll need to authenticate GH first.

```
git clone git@github.com:QuorumUS/quorum-site.git && cd quorum-site
```

Python dependencies not already installed will be installed in the virtualenv.

```
virtualenv-3.9 -p /opt/local/bin/python2.7 venv
./venv/bin/pip install -r tests/requirements.txt
```

Now the python side of thigns are set up. To run the server,

```
./venv/bin/python manage.py runserver_plus 0.0.0.0:8000
```

To open shell_plus,

```
./venv/bin/python manage.py shell_plus
```

To run backend tests locally, (Note: you'll need a Postgres server (with PostGIS
support) which you'll need to set up seperately, https://postgresapp.com/ is an
easy choice that can be installed with `brew install --cask postgres`).

```
USE_LOCAL_DB=True ./venv/bin/python manage.py test app -k
```
