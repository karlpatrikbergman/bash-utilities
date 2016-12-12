#!/usr/bin/env bash

# Retrieve ip address of docker container. If no argument is provided get ip address for last started container
# Copy ip address to clipboard
# Print ip address in terminal
dockip() {
    if [ $# -eq 0 ]
    then
        CONTAINER_NAME=$(docker ps -q)
    else
        CONTAINER_NAME="$@"
    fi
    CONTAINER_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINER_NAME})
    echo ${CONTAINER_IP} | xclip -sel c
    echo ${CONTAINER_IP}
}

# Argument is number of xtm nodes to start
run_xtm_nodes() {
    for i in `seq 1 $1`; do
        NODE_ID=$(docker run -d se-artif-prd.infinera.com/tm3k/trunk-hostenv)
        echo ${NODE_ID}
        dockip
    done
}

rm_docker_containers() {
    docker ps -q -a | xargs docker rm
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
    docker_clean_up
    docker rmi -f $(docker images -q)
}

# Good if you want to see daemon logging
run_docker_daemon() {
    /etc/init.d/docker start
}
