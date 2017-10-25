#!/usr/bin/env bash

# export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
# set -x

docker_get_ip_address() {
    if [ "$#" -ne 1 ]; then
        printf "Usage: ${FUNCNAME[0]} <container-name>\n"
    fi
    local readonly CONTAINER_NAME="${1}"
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINER_NAME}
}

docker_run_x_nr_of_containers() {
    if [[ $# -lt 2 ]] ; then
        printf "Usage: ${FUNCNAME[0]} <docker-image> <nr-of-containers-to-run> <docker-environment-vars>\n"
        printf "Example: ${FUNCNAME[0]} se-artif-prd.infinera.com/tm3k/trunk-hostenv:29.0 2 DEMO=true NOSIM=1\n"
        printf "<docker-environment-vars> are optional\n"
        return 1
    fi
    local readonly DOCKER_IMAGE="${1}"
    local readonly NR_OF_CONTAINERS_TO_RUN="${2}"
    local DOCKER_ENV_VARS

    for i in ${@:3}
    do
        DOCKER_ENV_VARS+=" -e ${i}"
    done

    local CONTAINER_ID CONTAINER_NAME CONTAINER_IP
    for i in `seq 1 ${NR_OF_CONTAINERS_TO_RUN}`; do
        CONTAINER_ID=$(docker run --privileged -dit ${DOCKER_ENV_VARS} ${DOCKER_IMAGE})
        CONTAINER_NAME=$(docker inspect --format='{{.Name}}' ${CONTAINER_ID})
        CONTAINER_NAME=${CONTAINER_NAME#"/"}
        CONTAINER_IP=$(docker_get_ip_address ${CONTAINER_NAME})
        CONTAINER_IP=${CONTAINER_IP#"/"}
        printf "${CONTAINER_NAME} : ${CONTAINER_IP}\n"
    done
}

docker_remove_stopped_containers() {
    docker ps -q -f status=exited | xargs docker rm
}

docker_remove_all_containers() {
    docker ps -q -a | xargs docker rm -f
}

docker_remove_dangling_volumes() {
    docker volume rm $(docker volume ls -qf dangling=true)
}

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
    docker_remove_all_containers
    docker_clean_up
    docker network prune -f

}

# Good if you want to see daemon logging
docker_run_daemon() {
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
docker_create_alias() {
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
