# Eric's Quorum Config

The anti-docker Quorum configuration

These are various notes/tools I've taken over the last year that I've tried to
clean up/document before committing to quorum-site. Comes without warranty.

## Setting up Quorum

*This is not the official Quorum setup docs, these are just notes from someone
who doesn't follow those docs.*

First install XCode by running `xcode-select --install`.

Next you need https://www.macports.org/. If you haven't used macports
it's simialar to brew but is designed more like Linux package managers and,
importantly, has better support of older software (ie python2).

Note macports claims it doesn't play well with brew also installed. I've found
as long as you're only installing casks brew will work with macports.

Here's the packages I have. You probably don't have to install all of these, and
can just install things as needed.

```
ddnsmasq                        @2.85           net/dnsmasq
elasticsearch                  @7.10.0         databases/elasticsearch
enchant2                       @2.3.0          textproc/enchant2
fortune                        @6.2.0-RELEASE  games/fortune
git                            @2.32.0         devel/git
git-crypt                      @0.6.0          devel/git-crypt
gnupg2                         @2.2.27         mail/gnupg2
gsed                           @4.8            textproc/gsed
htop                           @3.0.5          sysutils/htop
jq                             @1.6            sysutils/jq
libgeoip                       @1.6.12         devel/libgeoip
libmagic                       @5.40           sysutils/file
libxdg-basedir                 @1.2.2          devel/libxdg-basedir
luajit                         @2.1.0-beta3    lang/luajit
nginx                          @1.21.0         www/nginx
proj                           @5.2.0          gis/proj
py27-enchant                   @2.0.0          python/py-enchant
py27-gdal                      @3.2.3          python/py-gdal
py39-mypy                      @0.910          python/py-mypy
py39-pip                       @21.1.3         python/py-pip
py39-virtualenv                @20.4.7         python/py-virtualenv
python27                       @2.7.18         lang/python27
python39                       @3.9.6          lang/python39
ripgrep                        @13.0.0         textproc/ripgrep
tmux                           @3.2a           sysutils/tmux
todotxt                        @2.12.0         office/todotxt
xdg-utils                      @1.1.3          sysutils/xdg-utils
yarn                           @1.22.10        devel/yarn
zsh                            @5.8            shells/zsh
neovim
coreutils
```

(Note: `p27-enchant` and `py27-gdal` aren't actually used since we reinstall
those in a virtualenv, however installing the global versions ensures we have
the correct dependencies when we install them in the virtualenv)

In general to install something do `sudo port install python27 python39 git
[...more packages]`

The commands that result from this will be stored in `/opt/local/bin`. I'll
assume you have that in your `$PATH`.

Extract quorum-site somewhere, you'll need to authenticate GH first. Best to do
that with SSH: [Github has good docs for that](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).

To extract quorum-site,

```
$ git clone git@github.com:QuorumUS/quorum-site.git && cd quorum-site
```

Macports should already have been used to install system dependencies used by
some python libraries (for example, `gdal` and `enchant`). The rest will be
installed in a virtualenv:

```
$ virtualenv-3.9 -p /opt/local/bin/python2.7 venv
$ ./venv/bin/pip install -r tests/requirements.txt
```

While that's installing you'll need to get Bastion setup. Once that's done you can connect to the dev db like so,

```
$ ssh -p 27 <BASTION_USERNAME>@ec2-52-206-129-115.compute-1.amazonaws.com -L 5433:oh-god-are-we-allowed-to-terminate-the-dev-db.ck4wgl7u5wcg.us-east-1.rds.amazonaws.com:5432
```

I put that command here for illustrative purposes. You should set your ssh hosts
up in your `~/.ssh/config` (see the `ssh_config` file).

From bastion you'll also need to grab `quorum-crypt.pem`. You can put that in
`quorum-site` and run `git crypt unlock quorum-crypt.pem`. This decrypts
`quorum/settings/production_secrets.py`. Git-crypt will keep this file decrypted
as you switch branches (provided you don't modify it and you don't checkout
branches encrypted with a different password). We have special instructions you
need to follow if you ever need to modify this file.

Now the python side of things are set up. To run the server,

```
$ ./venv/bin/python manage.py runserver_plus 0.0.0.0:8000
```

To open shell_plus,

```
$ ./venv/bin/python manage.py shell_plus
```

In bash and zsh and you run `source ./venv/bin/activate` to put the correct
python and pip versions in your `$PATH`, as well as some other setup.

To run backend tests locally, (Note: you'll need a Postgres server (with PostGIS
support) which you'll need to set up seperately, https://postgresapp.com/ is an
easy choice that can be installed with `brew install --cask postgres`).

```
$ USE_LOCAL_DB=True ./venv/bin/python manage.py test app -k
```

For the frontend you should install [nvm](https://github.com/nvm-sh/nvm). The
easiest way is to run the shell script from their README. You can also install
the macports package and add `source /opt/local/share/nvm/init-nvm.sh` to your
shell. A couple notes (1) I'm pretty sure nvm only supports bash and zsh (2)
There doesn't seem to be very many people interested in keeping the macports
version of zsh out of date so use that at your own risk.

Similar to virtualenv you can "activate" the correct version by running `nvm
use` in your quorum-site directory. On your first run this will be more like,

```
$ nvm ls-remote
$ nvm install
$ nvm use
```

Once that's done we have three node packages we need to install dependencies
for:

```
$ (cd QuorumDesign && npm ci)
$ (cd QuoumGrassroots && npm ci)
$ npm install
```

For the frontend run gulp: `./node_modules/.bin/gulp`.

## Additional Tooling

Most of the executables in `bin` expect to be run in the correct environment.
See the `qq` command in `quorum.sh`. In general this means,

 * You have the correct python version selected, generally done by activating
   your virtualenv
 * You have the correct node version available.
 * You have all the relevant tools in your `$PATH`, python-wise this is already
   done when activating virtualenv but you should also add `node_modules/.bin`
   to your `$PATH`.

The reason for this is so (1) the scripts don't have to make too many
assumptions, for instance they don't try to guess and track down where certain
executables or files are and (2) setup logic can be assumed to be done
beforehand.

Additionally all the reasonable ones (the ones worth using) take a `--help`
option which will print a help message and immediately exit. It should be pretty
obvious which ones have this feature by inspecting the source.

## Elasticsearch

Get the package from macports.

Then, you need to copy over the config files from
`quorum-site/tests/elasticsearch`. For the macports version
these need to go in `/opt/local/etc/elasticsearch` and be
permissioned to `elasticsearch:elasticsearch`. You will need
to remove the `network.host` option in `elasticsearch.yml`
or elasticsearch will fail to start.

There's a few plugins you need to install listed in
`quorum-site/Dockerfile-elasticsearch-local`. The command is
in a slightly different spot and this needs to be installed
as elasticsearch:

```
$ sudo -u elasticsearch \
    /opt/local/share/elasticsearch/bin/elasticsearch-plugin \
    install analysis-kuromoji analysis-icu analysis-icu
```

Then just run the elasticsearch command as elasticsearch to
start the server.

```
$ sudo -u elasticsearch elasticsearch
```

For the application to recognize you're using a local server
you need two things:

 * `DOCKER_TESTING_LOCAL_ES=True`
 * `elasticsearch` host needs to point to localhost (use
   `/etc/hosts`)

## PyCharm

### Eslint

Pycharm does not detect eslint correctly. To set this up, open up the ESLint
settings in preferences.

```
[x] Manual ESLint configuration
    ESLint package: <QUORUM_SITE>/node_modules/eslint
    Working directories: <QUORUM_SITE>

Configration File:
    <QUORUM_SITE>/tests/.eslintrc

Run for files: {**/*,*}.{js,jsx}

(other options left blank)
```
