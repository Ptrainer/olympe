#!/usr/bin/env bash

set -eu
shopt -s globstar
source $PTRAINER/scripts/lib/pick.sh
source $PTRAINER/scripts/lib/log.sh

script_dir=$PTRAINER/scripts
cd $script_dir
pick -l {website,heroku,mandrill,newrelic,host}/**/*.sh
if [ ! -z $pick_result ]; then
    info "Executing $script_dir/$pick_result..."
    ./$pick_result
fi
