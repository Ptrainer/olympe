#!/usr/bin/env bash

set -eu
source $PTRAINER/scripts/lib/heroku.sh
source $PTRAINER/scripts/lib/pick.sh
source $PTRAINER/scripts/lib/log.sh
source $PTRAINER/scripts/lib/db.sh

backup_name="website_partial_$(date +%Y-%m-%d).dump"

info "Fetching table names..."
tables=$(list_tables website-db)

warning "You are going to be prompted to choose the tables YOU DO NOT WANT in your backup"
info "Press return to continue"
read
pick -m $tables

info "excluding the following tables:"
for table in $pick_result; do
    echo $table
done

heroku_dump_db website-db ptrainer-website-eu "$pick_result" $backup_name
info "Backup file saved"
