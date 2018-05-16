#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

source "${TOP_DIR}/utils.sh"

# dev tools
source ${TOP_DIR}/dev/vim.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/git.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/gerrit.sh "${TOP_DIR}" "${K_DIR}"
# dev tools

install_dev() {
    install_prompt git install_dev_git
    install_prompt vim install_dev_vim
    install_prompt gerrit install_dev_gerrit
}
