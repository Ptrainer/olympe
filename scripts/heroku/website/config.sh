#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/heroku.sh

heroku_cmd config -a ptrainer-website-eu
