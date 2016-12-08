#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/log.sh

hosts_file_path() {
    echo "/etc/hosts"
}

hosts_add_dns() {
    local ip=$1
    local domain_name=$2
    local host_file=$(hosts_file_path)

    info "Adding DNS redirect: $ip $domain_name"
    sudo /usr/bin/env bash -lc "echo $ip $domain_name >> $host_file"
}

hosts_add_nav_dns() {
    local ip

    if [ "$(uname)" == "Darwin" ]; then
        ip=$(docker-machine ip $NAV_MACHINE_NAME)
    else
        ip="localhost"
    fi

    hosts_add_dns $ip "ptrainer.dev"
    hosts_add_dns $ip "app.ptrainer.dev"
}
