#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

source "${TOP_DIR}/nvm.sh"

install_dev_node() {
    set -i
    _install_node
    _configure_node
    _install_yarn
    set +i
}

_install_yarn() {
    source "${NVM_DIR}/nvm.sh" >> /dev/null; \
    local yarn_in_system=$(npm list --global | grep yarn)
    if [[ "${yarn_in_system}" ==  *"yarn"* ]] ; then
        echo "Updating yarn"
        npm update --global yarn
    else
        echo "Installing yarn"
        npm install --global yarn;
    fi
    (source "${NVM_DIR}/nvm.sh" >> /dev/null; nvm reinstall-packages)
}

_install_node() {
    echo "Installing latest Node.JS"
    (
        source "${NVM_DIR}/nvm.sh" >> /dev/null; \
        nvm install node; \
        nvm use node;
    )
}

_configure_node() {
    echo "Configuring node and npm"
    (
        source "${NVM_DIR}/nvm.sh" >> /dev/null; \
        [[ -n "${http_proxy}" ]] && npm config set proxy "${http_proxy}"
        npm config set registry "http://registry.npmjs.org/"; \
        npm set strict-ssl false;
    )
}
