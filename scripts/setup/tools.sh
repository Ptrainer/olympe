#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/docker.sh

# Terminal selector helper
docker_pull "globidocker/term-picker-release"
# Sandboxed Heroku toolbelt
docker_build "heroku-cli" $PTRAINER/tools/heroku-cli
# Uselful for GNU tools
docker_pull "busybox"
