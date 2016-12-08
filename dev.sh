#!/usr/bin/env bash

set -eu
source $PTRAINER/scripts/lib/log.sh
source $PTRAINER/scripts/lib/docker.sh
source $PTRAINER/scripts/lib/compose.sh
source $PTRAINER/scripts/lib/docker-machine.sh
source $PTRAINER/scripts/lib/hosts.sh

step() {
    printf "\n"
    colored 190 "$1"
}

is_setup=false
git_step=false
restart=false

while getopts "igr?:" opt; do
    case "$opt" in
        i) is_setup=true;;
        g) git_step=true;;
        r) restart=true;;
    esac
done

docker-machine_init

docker_assert_version "1.10"
dc_assert_version "1.6"

if [ "$is_setup" = true ]; then
    step "Logging in to docker hub"
    docker login
fi

if [ "$is_setup" = true ] || [ "$git_step" = true ]; then
    step "Cloning / updating repositories"
    $PTRAINER/scripts/setup/git.sh
fi

step "Setting up local application config"
$PTRAINER/scripts/setup/default_config.sh

step "Installing tools"
$PTRAINER/scripts/setup/tools.sh

step "Setting up git remotes for Heroku"
$PTRAINER/scripts/setup/heroku.sh

step "Pulling images"
docker_pull "redis"

step "Building images"
for image in "website" "website-db"; do
    dc_build $image
done

if [ "$is_setup" = true ]; then
    step "Migrating database"
    $PTRAINER/scripts/website/database/migrate.sh
    step "Database migrated"
fi

if ! grep "ptrainer" $(hosts_file_path) &> /dev/null ; then
    step "Setting up development DNS"
    hosts_add_nav_dns
fi

if [ "$restart" = true ]; then
    step "Shutting down"
    dc_nav down
fi

step "Starting services"
dc_nav up -d
