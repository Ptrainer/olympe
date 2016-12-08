#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/log.sh
source $PTRAINER/scripts/lib/docker.sh
source $PTRAINER/scripts/lib/compose.sh
source $PTRAINER/scripts/lib/gnu.sh

in_heroku_cli() {
    docker run \
        --rm \
        -it \
        -v $(dc_volume heroku-data):/root \
        heroku-cli \
        "$@"
}

heroku_cmd() {
    in_heroku_cli heroku "$@"
}

heroku_run() {
    heroku_cmd run "$@"
}

heroku_remote_url() {
    heroku_cmd apps:info -a $1 |
        grep "Git URL" |
        awk '{print $3}' |
        sed 's/[[:space:]]//' # Trailing spaces
}

# We sometimes need to make sure we are logged in because subshell commands
# don't work because of TTY stuff
heroku_ensure_logged_in() {
    heroku_cmd auth:token
}

container_backup_dir="/root/db-backups"

heroku_fetch_db() {
    local backup_name=$1
    local application=$2

    local db_url_cmd="heroku pg:backups public-url -a $application"
    local fetch_db_cmd="
        mkdir -p $container_backup_dir && \
        curl -o $container_backup_dir/$backup_name \$($db_url_cmd)
    "

    heroku_ensure_logged_in

    in_heroku_cli bash -c "$fetch_db_cmd"
}

heroku_dump_db() {
    local service=$1
    local application=$2
    local excluded_tables=$3
    local backup_name=$4

    heroku_ensure_logged_in

    local credentials=$(heroku_cmd pg:credentials DATABASE_URL -a $application)
    local host=$(gnu expr match "$credentials" '.*host=\([^ ]\+\)')
    local port=$(gnu expr match "$credentials" '.*port=\([^ ]\+\)')
    local user=$(gnu expr match "$credentials" '.*user=\([^ ]\+\)')
    local password=$(gnu expr match "$credentials" '.*password=\([^ ]\+\)')
    local database=$(gnu expr match "$credentials" '.*dbname=\([^ ]\+\)')
    local exclude_pattern="\"($(echo "$excluded_tables" | tr '\n' '|'))\""

    local dump_db_cmd="pg_dump \
        --verbose \
        -Fc \
        --no-acl \
        --no-owner \
        --clean \
        -h $host \
        -p $port \
        -U $user \
        -T $exclude_pattern \
        $database \
        > $container_backup_dir/$backup_name
    "

    docker run \
        --rm \
        -e PGPASSWORD=$password \
        -v $(dc_volume heroku-data):/root \
        $(dc_image $service) \
        /bin/bash -c "$dump_db_cmd"
}

heroku_restore_db() {
    local service=$1
    local database=$2
    local user=$3
    local backup_name=$4

    local image=$(dc_image $service)
    local password=$(dc_run_volatile $service bash -c "echo -n \$POSTGRES_PASSWORD")

    info "Attempting to restore the database: $database"
    warning "Please make sure $service is running"

    docker run \
        --rm \
        -it \
        -v $(dc_volume heroku-data):/heroku:ro \
        -e PGPASSWORD=$password \
        --net $(dc_network) \
        $image \
        pg_restore \
            --verbose \
            --clean \
            --no-acl \
            --no-owner \
            -h $service \
            -U $user \
            -d $database \
            /heroku/db-backups/$backup_name
}

heroku_list_backups() {
    local pattern=$1

    in_heroku_cli bash -c "
        shopt -s nullglob && \
        for file in $container_backup_dir/$pattern*.dump; \
            do basename \$file; \
        done \
    " | tr -d '\r' # https://github.com/docker/docker/issues/8513
}
