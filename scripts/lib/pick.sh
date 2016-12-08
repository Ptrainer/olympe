#!/usr/bin/env bash

set -u

pick() {
    local result_file=$PTRAINER/tools/.term-picker_data
    local result_dir=$(dirname $result_file)

    args=$@ # Only way I found to forward arguments in a string for now

    # Here I use a hacky way to bypass the limitations caused by a non-native
    # docker deamon: we cannot easily share the host's /dev/tty
    docker run \
        -it \
        --rm \
        -v $result_dir:$result_dir \
        --entrypoint=/bin/sh \
        globidocker/term-picker-release \
        -lc "/pick $args > $result_file"

    pick_result=$(cat $result_file)
    rm -f $result_file
}
