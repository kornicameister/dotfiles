#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

source "${TOP_DIR}/utils.sh"

install_tools() {
    set -i
    install_prompt tlp _install_tlp
    install_prompt whatpulse _install_whatpulse
    install_prompt wakatime _install_wakatime
    set +i
}

_install_wakatime() {
    pip install wakatime --user --upgrade && echo "wakatime installed/upgraded"
    _install_wakatime_bash
}

_install_wakatime_bash() {
    bw_config=$HOME/.wakatime.cfg

    if [ ! -f $bw_config ]; then
        echo -n "wakatime api key: [ENTER]"
        read waka_api_key

        echo "wakatime.cfg" && cat > $bw_config << EOF
[settings]
api_key = $waka_api_key
debug = false
hidefilenames = false
exclude =
    ^COMMIT_EDITMSG$
    ^TAG_EDITMSG$
    ^/var/
    ^/etc/
    ^/tmp/
include =
    .*
offline = true
timeout = 30
hostname = $hostname
EOF
    else
        echo "$bw_config already exists"
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

