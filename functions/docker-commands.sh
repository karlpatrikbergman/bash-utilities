#!/usr/bin/env bash

# Retrieve ip address of docker container. If no argument is provided get ip address for last started container
# Copy ip address to clipboard
# Print ip address in terminal
dockip() {
    local CONTAINER_NAME
    if [ $# -eq 0 ]
    then
        CONTAINER_NAME=$(docker ps -q)
    else
        CONTAINER_NAME="$@"
    fi
    local readonly CONTAINER_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINER_NAME})
    echo ${CONTAINER_IP} | xclip -sel c
    echo ${CONTAINER_IP}
}

# Argument is number of xtm nodes to start
run_xtm_nodes() {
    local NODE_ID
    for i in `seq 1 $1`; do
        NODE_ID=$(docker run -e "DEMO=true" -e "NOSIM=1" --privileged -dit se-artif-prd.infinera.com/tm3k/trunk-hostenv:latest)
        echo ${NODE_ID}
    done
}

rm_stopped_docker_containers() {
    docker ps -q -f status=exited | xargs docker rm
}

rm_all_docker_containers() {
    docker ps -q -a | xargs docker rm -f
}

rm_dangling_volumes() {
    docker volume rm $(docker volume ls -qf dangling=true)
}
#rm_dangling_volumes

# ABOUT UNTAGGED IMAGES
# $ docker images --filter "dangling=true"
#
# This will display untagged images, that are the leaves of the images tree (not intermediary layers).
# These images occur when a new build of an image takes the repo:tag away from the image ID, leaving it as
# <none>:<none> or untagged. A warning will be issued if trying to remove an image when a container is
# presently using it. By having this flag it allows for batch cleanup like:
# $ docker rmi $(docker images -f "dangling=true" -q)

docker_clean_up() {
    #Delete containers and hopefully dangling volumes too?
    docker rm -v $(docker ps -a -q -f status=exited)

    #Delete all dangling images
    docker rmi $(docker images -f "dangling=true" -q)
    #or some one suggested
    #docker images -q --filter "dangling=true" | xargs -n1 -r docker rmi)

    #Remove unwanted volumes filling up in your disk
    #Maybe already done above, but just in case
    docker volume rm $(docker volume ls -qf dangling=true)
}

docker_clean_up_everything() {
    rm_all_docker_containers
    docker_clean_up

}

# Good if you want to see daemon logging
run_docker_daemon() {
    /etc/init.d/docker start
}

# Example:
# create_docker_alias pabe_test_machine tcp://172.16.15.230:2376 /home/qpabe/.docker/machine/machines/pabe-test-machine
#
# Remove alias:
# unalias alias-name
#
# Removes All aliases:
# alias -a
create_docker_alias() {
    if [ "$#" -ne 3 ]; then
        printf "Usage: create_docker_alias <alias> <remote-host> <cert-path>"
    fi
    local readonly ALIAS="${1}"
    local readonly REMOTE_HOST="${2}"
    local readonly CERT_PATH="${3}"
    alias ${ALIAS}="docker --tlsverify -H=${REMOTE_HOST} \
        --tlscacert=${CERT_PATH}/ca.pem \
        --tlscert=${CERT_PATH}/cert.pem \
        --tlskey=${CERT_PATH}/key.pem"
}

create_alias_docker_pabe_test_machine() {
    create_docker_alias pabe_test_machine tcp://172.16.15.230:2376 /home/qpabe/.docker/machine/machines/pabe-test-machine
}

get_container_ip_address() {
    if [ "$#" -eq 1 ]; then
        docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${1}"
    elif [ "$#" -eq 2 ]; then
        eval "${1} inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${2}"
    else
        printf "Usage with local docker host: get_container_ip_address <container-name>\n"
        printf "Usage with alias set to remote docker host: get_container_ip_address <docker-alias> <container-name>\n"
    fi
}