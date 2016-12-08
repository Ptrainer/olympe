#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/log.sh

dc_assert_version() {
    local min_bound=$1
    local version=$(docker-compose --version | sed -e 's/docker-compose \([[:digit:]]\.[[:digit:]]\.[[:digit:]]\).*/\1/g')

    if [[ $version < $min_bound ]]; then
        error "Your version of docker-compose ($version) is out of date (minimum $min_bound required)"
        exit
    fi
}

dc_project_prefix() {
    # from https://github.com/docker/compose/blob/master/compose/cli/command.py#L89-L90
    local base_name=$(basename $PTRAINER)

    echo $base_name |
        tr '[:upper:]' '[:lower:]' | # to lower
        sed 's/[^a-z0-9]//g'         # remove non alnum characters
}

dc_nav() {
    docker-compose -f $PTRAINER/docker-compose.yml "$@"
}

dc_image() {
    echo $(dc_project_prefix)_$1
}

dc_network() {
    echo $(dc_project_prefix)_default
}

dc_volume() {
    echo $(dc_project_prefix)_$1
}

dc_build() {
    local image=$1
    local image_tag=$(dc_image $1)

    if ! docker inspect $image_tag &> /dev/null ; then
        dc_nav build $image
    fi
}

dc_run_volatile() {
    dc_nav run --rm "$@"
}
