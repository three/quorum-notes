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

checks() {(
    nvm use node
    source "$QUORUM_ROOT/venv/bin/activate"
    cd "$QUORUM_ROOT"
    export PYTHONPATH="$QUORUMROOT"
    COMMON_ANCESTOR="$(git merge-base HEAD hotfix)"
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
# Sync Development files to basement.0
alias fullsync='rsync -rv --exclude-from "$QUORUM_TOOLS_DIR/rsync-exclude.txt" "$QUORUM_ROOT" "$QUORUM_REMOTE_SSH:$QUORUM_REMOTE_ROOT"'
