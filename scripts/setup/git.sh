#!/usr/bin/env bash

set -eu
source $PTRAINER/scripts/lib/log.sh

current_branch() {
    git rev-parse --abbrev-ref HEAD
}

pull_if_clean() {
    local repo=$(basename $1)

    cd $1
    git status &> /dev/null
    if git diff-files --quiet; then
        info "updating $repo"
        git pull origin $(current_branch)
    else
        warning "$repo has local changes"
    fi
}

clone_or_update() {
    repo=$1
    path=$PTRAINER/$2/$repo

    if [ ! -e $path ]; then
        git clone git@github.com:Ptrainer/$repo.git $path
    else
        pull_if_clean $path
    fi

}

pull_if_clean $PTRAINER

# Clone / update PTRAINER repos
clone_or_update ptrainer-website website