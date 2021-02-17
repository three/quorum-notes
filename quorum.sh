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

# Change directory to quorum-site
alias q='cd "$QUORUM_ROOT"'
# Run Jest tests
alias jest='nvm run node "$QUORUM_ROOT/node_modules/.bin/jest"'
alias jestd='nvm run node --inspect-brk "QUORUM_ROOT/node_modules/.bin/jest" --runInBand'
# Docker compose with fullstack configuration
alias fc='docker-compose -f docker-compose.yml -f docker/local/docker-compose.fullstack.yml'

# Wake baement.0 from its slumber
alias wakebasement='wakeonlan FC:AA:14:2A:AF:79'
# Sync Development files to basement.0
alias fullsync='rsync -C -rv --exclude-from="$QUORUM_TOOLS_DIR/rsync-exclude.txt" --exclude-from="$QUORUM_ROOT/.gitignore" "$QUORUM_ROOT/" "$QUORUM_REMOTE_SSH:$QUORUM_REMOTE_ROOT"'
# Checkout all files from the latest hotfix to QUORUM_ROOT
alias checkouthotfix='git --work-tree="$QUORUM_ROOT" checkout "$(hotfix)" -- .'

# SSH into bastion with port forwarding to both dev and prod
alias bsc='ssh -L 5433:quovid-19.ck4wgl7u5wcg.us-east-1.rds.amazonaws.com:5432 -L 5434:quorum-production.ck4wgl7u5wcg.us-east-1.rds.amazonaws.com:5432 -Nnf bastion'
# SSH into basemenet with 8000 and 8001 port forwarding
alias prc='ssh -L localhost:8000:localhost:8000 qdev@patrick.spongebob.link -L localhost:8001:localhost:8001 -L localhost:8443:localhost:8443 -Nnf'

# Docker compsoe with custom compose file and related commands
alias dc='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml"'
alias up='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml" up -d'
alias logs='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml" logs -f --tail=10'
alias managepy='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml" exec server python manage.py'
alias jest='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml" exec frontend ./node_modules/.bin/jest'

# Ripgrep, but only things we care about
alias qg="rg -g '*.js' -g '*.jsx' -g '*.py'"
