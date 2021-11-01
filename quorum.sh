if [[ ! -d "$QUORUM_ROOT" ]]; then
    export QUORUM_ROOT="$HOME/dev/quorum-site"
fi

if [[ ! -d "$QUORUM_TOOLS_DIR" ]]; then
    export QUORUM_TOOLS_DIR="$(dirname "$(realpath "$0")")"
fi

export PATH="$QUORUM_TOOLS_DIR/bin:$PATH"

add_to_path() {
    if [[ ! "$PATH" =~ (^|:)"$1"(:|$) ]]; then
        PATH="$PATH:$1"
    fi
}

alias q='pushd "$QUORUM_ROOT"'
qq() {
    alias sp=shellplus
    source "$QUORUM_ROOT/venv/bin/activate"
    add_to_path "$QUORUM_ROOT/node_modules/.bin"
}

setup_venv() {(
    set -exu
    virtualenv -p python2 venv
    ./venv/bin/pip -r tests/requirements.txt
)}

clear_node_cache() {
    if [[ -d node_modules ]]; then
        rm -rf node_modules/.cache
    else
        echo Unable to find node_modules >&2
        return 1
    fi
}

# Github helpers
# See https://github.com/three/dotfiles/blob/master/bin/browser for example browser comand
alias openpr='browser "https://github.com/QuorumUS/quorum-site/compare/hotfix/$(latesthotfix)...$(git branch --show-current)"'
opencommit() {browser "https://github.com/QuorumUS/quorum-site/commit/$(git rev-parse $1)"}

# Open file in PyCharm
alias pycharm='/Applications/PyCharm.app/Contents/bin/ltedit.sh'

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
alias runfrontend='while True; do node --max-old-space-size=8192 ./node_modules/.bin/gulp; done'

# Run backend tests
alias testpy='LOCAL_PG=1 ./venv/bin/python manage.py test'

# Ripgrep, but only things we care about
alias qg="rg --max-columns 200 -g '*.js' -g '*.jsx' -g '*.py'"

# elasticsearch stuff
alias runes='sudo -u elasticsearch /opt/elasticsearch/elasticsearch-7.5.2/bin/elasticsearch'
alias clear_elasticsearch='curl -XDELETE --user quorum_test:yULYQFAc7+EPbjdwFZoxUBf8PT8= localhost:9200/_all'

# Reload this config file
alias reload_quorum='source "$QUORUM_TOOLS_DIR/quorum.sh"'

alias kill_runserver='pkill -f runserver'
alias localpg_runall='(set -x; clear_elasticsearch && recreate_db && seed_cypress --safe && runserver -l)'

# Open a wip branch based on hotfix
mkwip() { git switch -c "wip/$1" "$(hotfix)" }

# Common hotfix aliases
alias diffhotfix='git diff --merge-base "origin/hotfix/$(latesthotfix)"'
alias checkout_hotfix='git switch --detach "origin/hotfix/$(latesthotfix)"'
alias merge_hotfix='git merge "origin/hotfix/$(latesthotfix)"'
alias update_hotfix='git branch --no-track -f latesthotfix "origin/hotfix/$(latesthotfix)"'

# Teleport standard aliases
alias tsh_login='tsh login --proxy=tele.quorum.us:443 --auth=local --user=eric.roberts'
alias lc_audit_testing='tsh ssh ubuntu@Lc_Audit_Testing_Server'
alias local_consultant_app='tsh ssh ubuntu@LocalConsultantApp'
alias local_consultant_db='tsh ssh ubuntu@LocalConsultantDB'
alias marketing='tsh ssh ubuntu@Marketing_Site'
alias metabase_firehose='tsh ssh ubuntu@Metabase_Firehose_Server'
alias oh_god_are_we_testing='tsh ssh ubuntu@OhGodAreWeTesting'
alias pganalyze='tsh ssh ubuntu@PGAnalyze'
alias sftp_server='tsh ssh ubuntu@SFTP_Server'
alias state_update='tsh ssh ubuntu@StateUpdate'
alias static_proxy='tsh ssh ubuntu@StaticProxy1'
alias update2='tsh ssh ubuntu@Update2'
alias es_prod_10='tsh ssh ubuntu@elasticsearch_prod_10'
alias es_prod_6='tsh ssh ubuntu@elasticsearch_prod_6'
alias es_prod_7='tsh ssh ubuntu@elasticsearch_prod_7'
alias es_prod_8='tsh ssh ubuntu@elasticsearch_prod_8'
alias es_prod_9='tsh ssh ubuntu@elasticsearch_prod_9'
alias es_dev_10='tsh ssh ubuntu@quorum-es-dev-node-10'
alias es_dev_8='tsh ssh ubuntu@quorum-es-dev-node-8'
alias es_dev_9='tsh ssh ubuntu@quorum-es-dev-node-9'
alias bulldozer='tsh ssh ubuntu@Bulldozer'
alias es_test='tsh ssh ubuntu@Elasticsearch'
alias grafana='tsh ssh ubuntu@Grafana'
alias grassroots_delivery='tsh ssh ubuntu@Grassroots_Delivery'
alias grassroots_delivery2='tsh ssh ubuntu@Grassroots_Delivery_2'
alias indiana='tsh ssh ubuntu@Indiana_Testing_Server'
alias new_state_update='tsh ssh ubuntu@New_State_Update'
alias new_update2='tsh ssh ubuntu@New_Update2'
alias new_grassroots_delivery='tsh ssh ubuntu@New_Grassroots_Delivery'
alias new_grassroots_delivery2='tsh ssh ubuntu@New_Grassroots_Delivery2'
alias new_metabase_firehose='tsh ssh ubuntu@New_Metabase_Firehose_Server'
