#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/log.sh

add_remote_if_absent() {
    local repository_dir=$1
    local remote=$2

    cd $repository_dir
    if ! git remote -v | grep heroku &> /dev/null ; then
        git remote add heroku $remote
        info "Added remote $remote"
    fi
}

add_remote_if_absent $PTRAINER/website/ptrainer-website "git@heroku.com:ptrainer-website-eu.git"
