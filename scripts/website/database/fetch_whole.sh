#!/usr/bin/env bash

set -eu
source $PTRAINER/scripts/lib/heroku.sh
source $PTRAINER/scripts/lib/log.sh

backup_name="website_$(date +%Y-%m-%d).dump"

heroku_fetch_db $backup_name "ptrainer-website-eu"
info "Backup file saved"
