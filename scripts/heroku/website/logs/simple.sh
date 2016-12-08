#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/heroku.sh

heroku_cmd logs -a ptrainer-website-eu
