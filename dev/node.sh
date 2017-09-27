#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

NVM_BINDING="${K_DIR}/b_nvm.sh"
NVM_DIR="${K_DIR}/nvm"

install_dev_node() {
    set -i
    _install_nvm
    _install_node
    _configure_node
    _install_yarn
    set +i
}

_install_yarn() {
    echo "Installing yarn"

    local yarn_apt="/etc/apt/sources.list.d/yarn.list"

    if [ ! -f "${yarn_apt}" ]; then
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee "${yarn_apt}"
    fi
    sudo apt-get update -qq
    sudo apt-get install yarn -y -qq
}

_install_nvm() {
    local nvm_repo="git@github.com:creationix/nvm.git"

    if [ ! -d "${NVM_DIR}" ]; then
        git clone "${nvm_repo}" "${NVM_DIR}"
    else
        cd "${NVM_DIR}"
        git reset --hard HEAD
        git fetch --all
        git checkout master
        git rebase origin/master
        cd -
    fi

    (cd "${NVM_DIR}" ; git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin` ; cd -)

    source "${NVM_DIR}/nvm.sh" && echo "nvm installed"

    if [ ! -f "${NVM_BINDING}" ]; then
    cat >"${NVM_BINDING}" <<EOL
export NVM_DIR="${NVM_DIR}"
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"  # This loads nvm
[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion
EOL
    fi
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
        npm config set registry "http://registry.npmjs.org/"; \
        npm set strict-ssl false;
    )
}
