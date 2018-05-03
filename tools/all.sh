#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

source "${TOP_DIR}/utils.sh"

install_tools() {
    set -i
    install_prompt tlp _install_tlp
    install_prompt preload _install_preload
    install_prompt checkinstall _install_checkinstall
    install_prompt tig _install_tig
    install_prompt purge_old_kernels _install_purge_old_kernels
    install_prompt whatpulse _install_whatpulse
    install_prompt resume-cli  _install_resume_cli
    install_prompt aria2 _install_aria
    set +i
}

_install_aria() {
    sudo apt update -qq && sudo apt install aria2 -yy -qq
}

_install_resume_cli() {
    if is_app_installed docker; then

        docker pull kornicameister/resume-cli:latest
        cat >>"${BASH_BINDING}" <<EOL
# resume-cli docker alias
alias resume="docker run -it --rm -v $(pwd):/app -w /app kornicameister/resume-cli:latest resume"
EOL

    elif is_app_installed nvm; then

        source "${NVM_DIR}/nvm.sh" >> /dev/null; nvm use node
        install_node_pkg resume-cli
        (source "${NVM_DIR}/nvm.sh" >> /dev/null; nvm reinstall-packages)

    else
        echo "No suitable way to install resume-cli"
    fi
}

_install_whatpulse() {
    local arch;
    local url;
    local target;
    local wp_dir="${K_DIR}/whatpulse"

    arch=$(getconf LONG_BIT)
    url="https://whatpulse.org/downloads/298/${arch}bit/"
    target="${K_DIR}/whatpulse.tar.gz"

    echo "Downloading WhatPulse from ${url}"

    rm -rf "${target}" "${wp_dir}"
    mkdir -p "${wp_dir}"

    if is_app_installed wget; then
        wget -O "${target}" "${url}"
    else
        die "No wget to download ${url}"
    fi

    # install qt deps
    sudo apt-get install libqtcore4 libqtwebkit4 libqt4-sql libqt4-sql-sqlite \
        libssl-dev libqtscript4-core libqtscript4-gui libqtscript4-network \
        libqtscript4-webkit libpcap0.8 libpcapnav0 -yy -qq

    # unpack the whatpulse over to wp_dir
    tar -zxvf "${target}" -C "${wp_dir}"

    # part where we need user interactions
    sudo "${wp_dir}/setup-input-permissions.sh"
    sudo setcap cap_net_raw,cap_net_admin=eip "${wp_dir}/whatpulse"

    # make the whatpulse globally available for launchers etc
    sudo ln -sf "${wp_dir}/whatpulse" /usr/local/bin/whatpulse

    # cleanup
    rm -rf "${target}"
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
