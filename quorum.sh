if [[ ! -d "$QUORUM_ROOT" ]]; then
    QUORUM_ROOT="$HOME/dev/quorum-site"
fi

if [[ ! -d "$QUORUM_REMOTE_SSH" ]]; then
    QUORUM_REMOTE_SSH="qdev@basement.0"
fi

if [[ ! -d "$QUORUM_REMOTE_ROOT" ]]; then
    QUORUM_REMOTE_ROOT="/home/qdev/quorum-site"
fi

if [[ ! -d "$QUORUM_TOOLS_DIR" ]]; then
    QUORUM_TOOLS_DIR="$(dirname "$(realpath "$0")")"
fi

QUORUM_DJANGIO_FILES="QuorumMobile/app/constants/djangio_cache.json _custom_event_djangio_cache.json _djangio_cache.json _new_grassroots_djangio_cache.json _unsubscribed_djangio_cache.json"

latesthotfix() {
    GIT_DIR="$(git rev-parse --git-dir)"
    [[ $? != 0 ]] && {
        echo "latesthotfix: git error"
        return 1
    }
    ls "$GIT_DIR/refs/remotes/origin/hotfix" | \
        grep '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*' | \
        sort -rV |
        head -n 1
}

hotfix() {
    echo "origin/hotfix/$(latesthotfix)"
}

checks() {(
    nvm use node
    source "$QUORUM_ROOT/venv/bin/activate"
    cd "$QUORUM_ROOT"
    export PYTHONPATH="$QUORUMROOT"
    COMMON_ANCESTOR="$(git merge-base HEAD origin/hotfix/$(latesthotfix))"
    ALTERED_FILES="$(git diff --name-only $COMMON_ANCESTOR)"
    [[ -z "$ALTERED_FILES" ]] && (
        echo "No files to check!"
        return 0
    )
    echo "Files to check:"
    echo "$ALTERED_FILES" | xargs python tests/check/__main__.py
    return $?
)}

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
alias dbconnect='ssh -L 5433:quorum-where-the-magic-happens.ck4wgl7u5wcg.us-east-1.rds.amazonaws.com:5432 -L 5434:quorum-production.ck4wgl7u5wcg.us-east-1.rds.amazonaws.com:5432 bastion'
# SSH into basemenet with 8000 and 8001 port forwarding
alias bmconnect='ssh -L localhost:8000:localhost:8000 qdev@basement.0 -L localhost:8001:localhost:8001 -L localhost:8443:localhost:8443'

# Docker compsoe with custom compose file and related commands
alias dc='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml"'
alias up='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml" up -d'
alias logs='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml" logs -f'
alias reload='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml" restart server frontend'
alias managepy='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml" exec server python manage.py'
alias jest='docker-compose -f "$QUORUM_TOOLS_DIR/docker-compose.yml" exec frontend ./node_modules/.bin/jest'
