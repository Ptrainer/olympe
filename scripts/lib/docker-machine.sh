#!/usr/bin/env bash

set -u
source $PTRAINER/scripts/lib/log.sh

nfs_exports_file_path() {
    echo "/etc/exports"
}

# https://github.com/boot2docker/boot2docker/issues/587#issuecomment-66935011
docker-machine_mount_nfs() {
    local nfs_exports_file=$(nfs_exports_file_path)
    local b2d_ip=$(docker-machine ip $NAV_MACHINE_NAME)
    local uid=$(id -u)

    if ! grep "/Users" $nfs_exports_file &> /dev/null; then
        info "Setting up nfs exports (requires root access)"
        sudo /usr/bin/env bash -lc "echo '/Users -mapall=$uid $b2d_ip'>> $nfs_exports_file"
        sudo nfsd restart
    fi

    info "Mounting /Users with nfs"
    docker-machine ssh $NAV_MACHINE_NAME \
        "sudo umount /Users;\
         sudo /usr/local/etc/init.d/nfs-client start &&\
         sleep 10 &&\
         sudo mount 192.168.99.1:/Users /Users -o rw,async,noatime,rsize=32768,wsize=32768,proto=tcp"
}

docker-machine_init() {
    if [ "$(uname)" == "Darwin" ]; then
        if ! docker-machine active | grep $NAV_MACHINE_NAME &> /dev/null; then
            info "docker machine: \"$NAV_MACHINE_NAME\" not started. Starting...."
            docker-machine start $NAV_MACHINE_NAME
            eval $(docker-machine env $NAV_MACHINE_NAME)
            docker-machine_mount_nfs
        else
            info "docker machine: \"$NAV_MACHINE_NAME\" already started."
        fi
    fi
}
