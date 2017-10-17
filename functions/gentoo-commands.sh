#!/bin/bash - 

gentoo_install_hipchat() {
    sudo layman -a hossie
    sudo eix-sync
    sudo emerge --autounmask-write net-im/hipchat
    sudo emerge net-im/hipchat
}

gentoo_install_custom_packages() {
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

gentoo_add_me_to_usergroups() {
    sudo usermod -a -G docker pabe
    sudo usermod -a -G wireshark pabe
}

gentoo_add_docker_as_service() {
    sudo rc-update add docker default
    sudo service docker start
}
