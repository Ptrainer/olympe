#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/compose.sh
source $PTRAINER/scripts/lib/gnu.sh

list_tables() {
    local service=$1

    dc_run_volatile \
        $service \
        bash -c "
            PGPASSWORD=\$POSTGRES_PASSWORD \
            psql \
                -h $service \
                -U \$POSTGRES_USER <<-EOF
					\\x off
					\\dt
					EOF
        " | # The tabs above are intentional: http://unix.stackexchange.com/a/76483
    awk 'NR >= 4 {print $3}' |
    $(gnu_cmd head -n -2)
}
