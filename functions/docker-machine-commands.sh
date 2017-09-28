#!/usr/bin/env bash

#set -o nounset # Treat unset variables as an error

connect_shell_to_machine() {
    if [ -z "$1" ] ; then
        printf "No machine name supplied\n"
        printf  "connect_shell_to_machine $1\n"
        exit 1;
    fi

    eval "$(docker-machine env $1)"
    printf  "docker-machine environment set to: $1\n"
}

disconnect_shell_from_any_machines() {
    eval $(docker-machine env -u)
}



