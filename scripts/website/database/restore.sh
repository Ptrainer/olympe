#!/usr/bin/env bash

set -eu
source $PTRAINER/scripts/lib/log.sh
source $PTRAINER/scripts/lib/heroku.sh

backup_files=$(heroku_list_backups website)

if [ -z "$backup_files" ]; then
    error "No backup files"
    exit
fi

info "Which backup file do you want to restore ?"
select backup_file in $backup_files; do
    for file in $backup_files; do
        if [[ $file = $backup_file ]]; then
            heroku_restore_db website-db website website $backup_file
            exit ;
        fi
    done
    error "Please answer with a valid number"
done
