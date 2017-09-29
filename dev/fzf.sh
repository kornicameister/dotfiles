#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

FZF_HOME="${K_DIR}/fzf"
FZF_BINDING="${K_DIR}/b_fzf.sh"

source "${TOP_DIR}/utils.sh"

install_dev_fzf() {
    _install_fzf
    _install_fzf_binding
}

_install_fzf() {
    echo "Installing fzf"

    local fzf_repo="https://github.com/junegunn/fzf.git"

    if [[ -d "${FZF_HOME}" ]]; then
        pushd "${FZF_HOME}"
        git fetch --all
        git rebase origin/master
        popd
    else
        git clone "${fzf_repo}" "${FZF_HOME}" --depth 1
    fi
    yes | ~/.fzf/install >> /dev/null
}

_install_fzf_binding() {
    if [ ! -f "${FZF_BINDING}" ]; then
    cat >"${FZF_BINDING}" <<EOL
export FZF_HOME=${FZF_HOME}
EOL
    fi
}
