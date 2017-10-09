#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

source "${TOP_DIR}/utils.sh"

# dev tools
source ${TOP_DIR}/dev/fzf.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/vim.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/node.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/git.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/gerrit.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/python.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/bash.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/ruby.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/travis.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/dev/elm.sh "${TOP_DIR}" "${K_DIR}"
# dev tools

install_dev() {
    install_prompt git install_dev_git
    install_prompt python install_dev_python
    install_prompt vim install_dev_vim
    install_prompt fzf install_dev_fzf
    install_prompt bash install_dev_bash
    install_prompt node install_dev_node
    install_prompt gerrit install_dev_gerrit
    install_prompt ruby install_dev_ruby
    install_prompt travis install_dev_travis
    install_prompt elm install_dev_elm
}

