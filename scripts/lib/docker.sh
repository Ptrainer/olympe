#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/log.sh

docker_assert_version() {
    local min_bound=$1
    local version=$(docker --version | sed -e 's/.* version \([[:digit:]]\.[[:digit:]]\.[[:digit:]]\).*/\1/g')
    if [[ $version < $min_bound ]]; then
        error "Your version of docker ($version) is out of date (minimum $min_bound required)"
        exit
    fi
}

# Pulls an image if it does not exist
docker_pull() {
    local image=$1

    if ! docker inspect $image &> /dev/null ; then
        docker pull $image
    fi
}

# Builds an image if it does not exist
docker_build() {
    local name=$1
    local path=$2

    if ! docker inspect $name &> /dev/null ; then
        docker build -t $name $path
    fi
}
