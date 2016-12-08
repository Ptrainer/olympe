#!/usr/bin/env bash

set -u
source $NAV/scripts/lib/log.sh

bluesky_mail_dir="$NAV/bluesky/nav-bluesky/tmp/letter_opener"
chronos_mail_dir="$NAV/chronos/nav-chronos/tmp/letter_opener"

mkdir -p $bluesky_mail_dir $chronos_mail_dir

if [ "$(uname)" == "Darwin" ]; then
    if which fswatch &> /dev/null; then
        fswatch \
            -r \
            $bluesky_mail_dir \
            $chronos_mail_dir |
                while read file; do
                    if echo "$file" | grep '.html' &> /dev/null; then
                        colored 111 "Mail detected: $file"
                        open $file
                    fi
                done
    else
        error "Please install fswatch"
    fi
else
    if which inotifywait &> /dev/null; then
        inotifywait \
            -mr \
            -e close_write \
            --format "%w%f" \
            $bluesky_mail_dir \
            $chronos_mail_dir |
                while read file; do
                    colored 111 "Mail detected: $file"
                    xdg-open $file
                done
    else
        error "Please install inotifywait"
    fi
fi
