#!/usr/bin/env bash

gnu_cmd() {
    echo "
        docker run \
        --rm \
        -i \
        busybox \
        $@
    "
}

gnu() {
    docker run \
        --rm \
        -i \
        busybox \
        "$@"
}
