#!/usr/bin/env bash

set -eu
source $PTRAINER/scripts/lib/compose.sh

dc_nav up -d website-db
dc_run_volatile website rake db:migrate
