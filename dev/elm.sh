#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

install_dev_elm() {
    set -i
    _install_elm_packages
    set +i
}

_install_elm_packages() {
    source "${NVM_DIR}/nvm.sh" >> /dev/null;
    nvm use node
    for pkg in "elm" "elm-test" "elm-oracle" "elm-format"; do
        _install_elm_package "${pkg}"
    done
    nvm reinstall-packages
}

_install_elm_package(){
    local pkg="${1}"
    local in_system=$(npm list --global | grep ${pkg})

    if [[ "${in_system}" ==  *"gerrit"* ]] ; then
        echo "Updating ${pkg}"
        npm update --global "${pkg}"
    else
        echo "Installing ${pkg}"
        npm install --global "${pkg}"
    fi
}

