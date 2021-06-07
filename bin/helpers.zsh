get_dev_db_password() {
    grep 'DEV_DB_AND_RDS_TEST_DB_PASSWORD_QUORUM_DJANGO_USER \=' quorum/settings/production_secrets.py | \
        sed -E 's/[A-Z_]+ \= r?"([a-zA-Z0-9]+)"$/\1/'
}

die() {
    print -- "$1" >&2
    exit 1
}
