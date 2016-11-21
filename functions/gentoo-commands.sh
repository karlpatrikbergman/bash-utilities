#!/bin/bash - 

function install_custom_packages() {
    sudo emerge --autounmask-write \
    app-admin/pass \
    x11-misc/flow-pomodoro \
    media-sound/spotify \
    app-emulation/docker-machine \
    app-emulation/docker-compose \
    app-emulation/vagrant \
    dev-java/maven-bin \
    net-analyzer/wireshark
}

function add_me_to_usergroups() {
    sudo usermod -a -G docker pabe
    sudo usermod -a -G wireshark pabe
}