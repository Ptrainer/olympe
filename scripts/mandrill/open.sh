#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/heroku.sh

username=$(heroku_cmd config:get MANDRILL_USERNAME -a ptrainer-website-eu)
echo "https://mandrillapp.com/login/?username=$username"
