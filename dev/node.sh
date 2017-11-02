#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

export NVM_BINDING="${K_DIR}/b_nvm.sh"
export NVM_DIR="${K_DIR}/nvm"

install_dev_node() {
    set -i
    _install_nvm
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
export NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist
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
