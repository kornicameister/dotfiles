#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

source "${TOP_DIR}/utils.sh"

install_os() {
    _install_tweaks
    _install_numix
}

_install_numix() {
    sudo apt-add-repository ppa:numix/ppa -y
    sudo apt-get update -qq
    sudo apt-get install numix-gtk-theme numix-icon-theme-circle
}

_install_tweaks() {
    sudo add-apt-repository ppa:philip.scott/elementary-tweaks -y
    sudo apt-get update -qq
    sudo apt-get install elementary-tweaks -yy -qq
}
