#!/usr/bin/env bash

set -eu
source $PTRAINER/scripts/lib/heroku.sh

heroku_run rails c -a ptrainer-website-eu
