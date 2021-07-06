which realpath >/dev/null || (
    echo "No command realpath. You're probably on OSX and don't have coreutils installed."
    echo "Try: brew install coreutils"
)

if [[ ! -d "$QUORUM_ROOT" ]]; then
    export QUORUM_ROOT="$HOME/dev/quorum-site"
fi

if [[ ! -d "$QUORUM_TOOLS_DIR" ]]; then
    export QUORUM_TOOLS_DIR="$(dirname "$(realpath "$0")")"
fi

export PATH="$QUORUM_TOOLS_DIR/bin:$PATH"

QUORUM_DJANGIO_FILES="QuorumMobile/app/constants/djangio_cache.json _custom_event_djangio_cache.json _djangio_cache.json _new_grassroots_djangio_cache.json _unsubscribed_djangio_cache.json"

hotfix() {
    echo "origin/hotfix/$(latesthotfix)"
}

diffhotfix() {(
    CURRENT_HOTFIX="$(hotfix)"
    MERGE_BASE="$(git merge-base HEAD "$CURRENT_HOTFIX")"
    git diff "$MERGE_BASE"
)}

quorum_setup_env() {
    cd "$QUORUM_ROOT" && {
        source ./venv/bin/activate
        nvm use
        PATH="$PATH:$(pwd)/node_modules/.bin"
    }
}

# Override bad default behaviour of npx
alias npx='npx --no-install'

# Github helpers
alias openpr='browser "https://github.com/QuorumUS/quorum-site/compare/hotfix/$(latesthotfix)...$(git branch --show-current)"'
opencommit() {browser "https://github.com/QuorumUS/quorum-site/commit/$(git rev-parse $1)"}

# Open file in PyCharm
alias ltedit='/Applications/PyCharm.app/Contents/bin/ltedit.sh'

# Change directory to quorum-site
alias q='cd "$QUORUM_ROOT"'
alias qq='quorum_setup_env'

# Run jest tests in debugger
jestd() {
    JEST_EXECUTABLE="$(whence -p jest)"
    if [[ -z $JEST_EXECUTABLE ]]; then
        echo jest not found on \$PATH >&2
        return 1
    fi
    node inspect -- "$JEST_EXECUTABLE" $@
}

# Run the frontend
alias runfrontend='nvm run ./node_modules/.bin/gulp'
alias runfrontend_restart='while True; do nvm run --max-old-space-size=8192 ./node_modules/.bin/gulp; done'

alias testpy='LOCAL_PG=1 ./venv/bin/python manage.py test'
alias sp='./venv/bin/python manage.py shell_plus'

# Docker stuff
alias docker_compose_fullstack='docker-compose -f docker-compose.yml -f docker/local/docker-compose.fullstack.yml'
#alias qq='docker run -v "$PWD:/code:delegated" -v "$HOME/dev/home:/root" --rm -it qrunner zsh'
alias qp='docker run -v "$PWD:/code:delegated" -v "$HOME/dev/home:/root" -p 8000:8000 --rm -it qrunner zsh'
alias build_qrunner='(cd "$QUORUM_TOOLS_DIR/qrunner" && docker build -t qrunner .)'

# Checkout all files from the latest hotfix to QUORUM_ROOT
alias checkouthotfix='git --work-tree="$QUORUM_ROOT" checkout "$(hotfix)" -- .'

# SSH into bastion with port forwarding to both dev and prod
alias bsc='ssh -L 5433:oh-god-are-we-allowed-to-terminate-the-dev-db.ck4wgl7u5wcg.us-east-1.rds.amazonaws.com:5432 -L 5434:quorum-production.ck4wgl7u5wcg.us-east-1.rds.amazonaws.com:5432 -Nnf bastion'

# Ripgrep, but only things we care about
alias qg="rg -g '*.js' -g '*.jsx' -g '*.py'"

alias runes='sudo -u elasticsearch elasticsearch'
alias clear_elasticsearch='curl -XDELETE --user quorum_test:yULYQFAc7+EPbjdwFZoxUBf8PT8= localhost:9200/_all'

alias reload_quorum='source "$QUORUM_TOOLS_DIR/quorum.sh"'
mkwip() { git switch -c "wip/$1" "$(hotfix)" }
