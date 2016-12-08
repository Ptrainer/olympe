#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/heroku.sh

heroku_cmd logs -t -a ptrainer-website-eu
