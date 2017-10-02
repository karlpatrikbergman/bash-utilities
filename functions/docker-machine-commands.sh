#!/usr/bin/env bash

#set -o nounset # Treat unset variables as an error

# Connect current shell to a docker-machine
docker_machine_connect() {
    if [ -z "$1" ] ; then
        printf "No machine name supplied\n"
        printf  "connect_shell_to_machine $1\n"
        exit 1;
    fi

    eval "$(docker-machine env $1)"
    printf  "docker-machine environment set to: $1\n"
}

# Disconnect current shell from a docker-machine
docker_machine_disconnect() {
    eval $(docker-machine env -u)
}

docker_machine_status() {
    env | grep DOCKER
}


