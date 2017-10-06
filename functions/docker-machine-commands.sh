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

docker_machine_create_on_remote_host() {
    if [[ $# -ne 5 ]] ; then
        printf "Usage: ${FUNCNAME[0]} <host-ip-number> <path-to-ssh-key> <a-user-on-host> <ssh-port> <docker-machine-name\n"
        printf "Example: ${FUNCNAME[0]} 172.16.15.230 ~/.ssh/id_rsa root 22 centos-docker-machine-1\n"
        return 1
    fi

    local readonly HOST_IP_NUMBER="${1}"
    local readonly PATH_TO_SSH_KEY="${2}"
    local readonly A_USER_ON_HOST="${3}"
    local readonly SSH_PORT="${4}"
    local readonly DOCKER_MACHINE_NAME="${5}"

    docker-machine --debug create -d generic \
      --generic-ip-address ${HOST_IP_NUMBER} \
      --generic-ssh-key ${PATH_TO_SSH_KEY} \
      --generic-ssh-user ${A_USER_ON_HOST} \
      --generic-ssh-port ${SSH_PORT} \
        ${DOCKER_MACHINE_NAME}
}

docker_machine_copy_public_ssh_key_to_vm() {
    if [[ $# -ne 3 ]] ; then
        printf "Usage: ${FUNCNAME[0]} <path-to-public-ssh-key> <user@host> <password>\n"
        printf "Example: ${FUNCNAME[0]} ~/.ssh/id_rsa.pub john@somehost johns-password\n"
        return 1
    fi
    local readonly PATH_TO_SSH_KEY="${1}"
    local readonly USER_AT_HOST="${2}"
    local readonly PASSWORD="${3}"

    sshpass -p ${PASSWORD} ssh-copy-id -i ${PATH_TO_SSH_KEY} ${USER_AT_HOST}
}

# How do I automate ssh/sudo with password?
install_net_tools() {
    if [[ $# -ne 1 ]] ; then
        printf "Usage: ${FUNCNAME[0]} <sudouser@yumbasedhost>\n"
        return 1
    fi
    local readonly USER_AT_HOST="${1}"
    ssh ${USER_AT_HOST} sudo yum -y install net-tools
}

stop_firewalld() {
    if [[ $# -ne 1 ]] ; then
        printf "Usage: ${FUNCNAME[0]} <sudouser@systemddhost>\n"
        return 1
    fi
    local readonly USER_AT_HOST="${1}"
    ssh ${USER_AT_HOST} sudo systemctl stop firewalld
}

restart_docker_daemon() {
    if [[ $# -ne 1 ]] ; then
        printf "Usage: ${FUNCNAME[0]} <sudouser@systemddhost>\n"
        return 1
    fi
    local readonly USER_AT_HOST="${1}"
    ssh ${USER_AT_HOST} sudo systemctl restart docker
}

docker_machine_fix_vm_before_docker_engine_installation() {
    if [[ $# -ne 3 ]] ; then
        printf "Usage: ${FUNCNAME[0]} <path-to-public-ssh-key> <user@host> <password>\n"
        printf "Example: ${FUNCNAME[0]} ~/.ssh/id_rsa.pub pabe@172.16.15.144 some-password\n"
        return 1
    fi
    local readonly PATH_TO_SSH_KEY="${1}"
    local readonly USER_AT_HOST="${2}"
    local readonly PASSWORD="${3}"

    docker_machine_copy_public_ssh_key_to_vm  ${PATH_TO_SSH_KEY} ${USER_AT_HOST} ${PASSWORD}
    install_net_tools ${USER_AT_HOST}
    stop_firewalld ${USER_AT_HOST}
    restart_docker_daemon ${USER_AT_HOST}
}