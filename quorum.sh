which realpath >/dev/null || (
    echo "No command realpath. You're probably on OSX and don't have coreutils installed."
    echo "Try: brew install coreutils"
)

if [[ ! -d "$QUORUM_ROOT" ]]; then
    export QUORUM_ROOT="$HOME/dev/quorum-site"
fi

if [[ ! -d "$QUORUM_REMOTE_SSH" ]]; then
    export QUORUM_REMOTE_SSH="qdev@patrick.spongebob.link"
fi

if [[ ! -d "$QUORUM_REMOTE_ROOT" ]]; then
    export QUORUM_REMOTE_ROOT="/home/qdev/quorum-site"
fi

if [[ ! -d "$QUORUM_TOOLS_DIR" ]]; then
    export QUORUM_TOOLS_DIR="$(dirname "$(realpath "$0")")"
fi

export PATH="$QUORUM_TOOLS_DIR/bin:$PATH"

QUORUM_DJANGIO_FILES="QuorumMobile/app/constants/djangio_cache.json _custom_event_djangio_cache.json _djangio_cache.json _new_grassroots_djangio_cache.json _unsubscribed_djangio_cache.json"

latesthotfix() {
    git branch -a | \
        grep 'remotes/origin/hotfix' | \
        grep -o '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*' | \
        sort -rV |
        head -n 1
}

hotfix() {
    echo "origin/hotfix/$(latesthotfix)"
}

diffhotfix() {(
    CURRENT_HOTFIX="$(hotfix)"
    MERGE_BASE="$(git merge-base HEAD "$CURRENT_HOTFIX")"
    git diff "$MERGE_BASE"
)}

# Github helpers
alias openpr='browser "https://github.com/QuorumUS/quorum-site/compare/hotfix/$(latesthotfix)...$(git branch --show-current)"'

# Open file in PyCharm
alias ltedit='/Applications/PyCharm.app/Contents/bin/ltedit.sh'

# Change directory to quorum-site
alias q='cd "$QUORUM_ROOT"'

# Run Jest tests
alias jest='nvm run node "$QUORUM_ROOT/node_modules/.bin/jest"'
alias jestd='nvm run node --inspect-brk "$QUORUM_ROOT/node_modules/.bin/jest" --runInBand'

# Run the server
# alias runserver='./venv/bin/python manage.py runserver_plus 0.0.0.0:8000'

# Run the frontend
alias runfrontend='nvm run 10 ./node_modules/.bin/gulp'
alias runfrontend_restart='while True; do nvm run 10 --max-old-space-size=8192 ./node_modules/.bin/gulp; done'

alias testpy='LOCAL_PG=1 ./venv/bin/python manage.py test'
alias sp='./venv/bin/python manage.py shell_plus'

# Docker stuff
alias docker_compose_fullstack='docker-compose -f docker-compose.yml -f docker/local/docker-compose.fullstack.yml'
alias qq='docker run -v "$PWD:/code:delegated" -v "$HOME/dev/home:/root" --rm -it qrunner zsh'
alias qp='docker run -v "$PWD:/code:delegated" -v "$HOME/dev/home:/root" -p 8000:8000 --rm -it qrunner zsh'
alias build_qrunner='(cd "$QUORUM_TOOLS_DIR/qrunner" && docker build -t qrunner .)'

# Checkout all files from the latest hotfix to QUORUM_ROOT
alias checkouthotfix='git --work-tree="$QUORUM_ROOT" checkout "$(hotfix)" -- .'

# SSH into bastion with port forwarding to both dev and prod
alias bsc='ssh -L 5433:oh-god-are-we-allowed-to-terminate-the-dev-db.ck4wgl7u5wcg.us-east-1.rds.amazonaws.com:5432 -L 5434:quorum-production.ck4wgl7u5wcg.us-east-1.rds.amazonaws.com:5432 -Nnf bastion'

# Ripgrep, but only things we care about
alias qg="rg -g '*.js' -g '*.jsx' -g '*.py'"

