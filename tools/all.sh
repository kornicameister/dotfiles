#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

source "${TOP_DIR}/utils.sh"

install_tools() {
    install_prompt tlp _install_tlp
    install_prompt preload _install_preload
    install_prompt checkinstall _install_checkinstall
    install_prompt tig _install_tig
    install_prompt purge_old_kernels _install_purge_old_kernels
}

_install_tlp() {
    sudo add-apt-repository ppa:linrunner/tlp -y
    sudo apt-get update -qq
    sudo apt-get install tlp tlp-rdw indicator-cpufreq -yy -qq
    sudo tlp start
}

_install_purge_old_kernels() {
    local url="https://raw.githubusercontent.com/jarnos/bikeshed/patch-1/purge-old-kernels"
    sudo -EH curl -L -o /usr/local/bin/purge-old-kernels \
        https://raw.githubusercontent.com/jarnos/bikeshed/patch-1/purge-old-kernels \
        -z /usr/local/bin/purge-old-kernels
    sudo -EH chmod +x /usr/local/bin/purge-old-kernels
}

_install_preload() {
    # https://itsfoss.com/improve-application-startup-speed-with-preload-in-ubuntu/
    sudo -EH apt-get install preload -yy -qq
}

_install_checkinstall() {
    # https://help.ubuntu.com/community/CheckInstall
    sudo -EH apt-get install checkinstall -yy -qq
}

_install_tig() {
    # text-mode interface for git https://github.com/jonas/tig
    sudo -EH apt-get install tig -yy -qq
}
