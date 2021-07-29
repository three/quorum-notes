which realpath >/dev/null || (
    echo "No command realpath. You're probably on OSX and don't have coreutils installed." >&2
    echo "Try: brew install coreutils or port install coreutils" >&2
)

if [[ ! -d "$QUORUM_ROOT" ]]; then
    export QUORUM_ROOT="$HOME/dev/quorum-site"
fi

if [[ ! -d "$QUORUM_TOOLS_DIR" ]]; then
    export QUORUM_TOOLS_DIR="$(dirname "$(realpath "$0")")"
fi

export PATH="$QUORUM_TOOLS_DIR/bin:$PATH"

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
# Using qq adds node_modules/.bin to your PATH, which takes care of most npx use cases
alias npx='npx --no-install'

# Github helpers
# See https://github.com/three/dotfiles/blob/master/bin/browser for example browser comand
alias openpr='browser "https://github.com/QuorumUS/quorum-site/compare/hotfix/$(latesthotfix)...$(git branch --show-current)"'
opencommit() {browser "https://github.com/QuorumUS/quorum-site/commit/$(git rev-parse $1)"}

# Open file in PyCharm
alias pycharm='/Applications/PyCharm.app/Contents/bin/ltedit.sh'

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

# Run backend tests
alias testpy='LOCAL_PG=1 ./venv/bin/python manage.py test'

# Docker stuff (outdated)
alias docker_compose_fullstack='docker-compose -f docker-compose.yml -f docker/local/docker-compose.fullstack.yml'
#alias qq='docker run -v "$PWD:/code:delegated" -v "$HOME/dev/home:/root" --rm -it qrunner zsh'
alias qp='docker run -v "$PWD:/code:delegated" -v "$HOME/dev/home:/root" -p 8000:8000 --rm -it qrunner zsh'
alias build_qrunner='(cd "$QUORUM_TOOLS_DIR/qrunner" && docker build -t qrunner .)'

# Checkout all files from the latest hotfix to QUORUM_ROOT
alias checkouthotfix='git --work-tree="$QUORUM_ROOT" checkout "$(hotfix)" -- .'

# SSH into bastion with port forwarding to both dev and prod
alias bsc='ssh -Nnf qdb'

# Ripgrep, but only things we care about
alias qg="rg --max-columns 200 -g '*.js' -g '*.jsx' -g '*.py'"

# elasticsearch stuff
alias runes='sudo -u elasticsearch elasticsearch'
alias clear_elasticsearch='curl -XDELETE --user quorum_test:yULYQFAc7+EPbjdwFZoxUBf8PT8= localhost:9200/_all'

# Reload this config file
alias reload_quorum='source "$QUORUM_TOOLS_DIR/quorum.sh"'

# Open a wip branch based on hotfix
mkwip() { git switch -c "wip/$1" "$(hotfix)" }
