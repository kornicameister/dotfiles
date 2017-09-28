#!/bin/bash

TOP_DIR=${1}
K_DIR=${2}

GERRIT_BINDING="${K_DIR}/b_gerrit.sh"

install_dev_gerrit() {
    (set -i ; _install_cli ; set +i)
    _install_binding
}

_install_cli() {
    source "${NVM_DIR}/nvm.sh" >> /dev/null; \

    nvm use node
    local in_system=$(npm list --global | grep gerrit)
    if [[ "${in_system}" ==  *"gerrit"* ]] ; then
        echo "Updating gerrit-cli"
        npm update --global gerrit-cli
    else
        echo "Installing gerrit-cli"
        npm install --global gerrit-cli
    fi

    (source "${NVM_DIR}/nvm.sh" >> /dev/null; nvm reinstall-packages)
}

_install_binding() {
    if [ ! -f "${GERRIT_BINDING}" ]; then
    cat >"${GERRIT_BINDING}" <<EOL
. <(gerrit completion)
EOL
    fi
}
