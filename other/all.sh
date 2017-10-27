#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

source "${TOP_DIR}/utils.sh"

# dev tools
source ${TOP_DIR}/other/spotify.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/other/chrome.sh "${TOP_DIR}" "${K_DIR}"
# dev tools

install_other() {
    install_prompt spotify install_spotify
    install_prompt chrome install_chrome
    install_prompt httpie _install_httpie
}

_install_httpie() {
    # sudo -EH apt-get install httpie
    sudo -EH pip install --upgrade https://github.com/jakubroztocil/httpie/archive/master.tar.gz
}

