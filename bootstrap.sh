#!/bin/bash

# Keep track of the top dir
TOP_DIR="$(cd $(dirname "$0") && pwd)"

# Check for uninitialized variables, a big cause of bugs
NOUNSET="${NOUNSET:-}"
if [[ -n "${NOUNSET}" ]]; then
    set -o nounset
fi

DEBUG=0
INSTALL=1
PURGE=0
UPDATE_START_POINT_ONLY=0

ME="${USER}"
K_DIR="${HOME}/.k_stuff"
K_START_POINT="${K_DIR}/k.sh"

source ${TOP_DIR}/globals
source ${TOP_DIR}/bash/fn.sh
source ${TOP_DIR}/bash/aliases.sh
source ${TOP_DIR}/utils.sh

source ${TOP_DIR}/dev/all.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/other/all.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/tools/all.sh  "${TOP_DIR}" "${K_DIR}"

if lsb_release -a | grep elementary; then
    source ${TOP_DIR}/os/elementary.sh "${TOP_DIR}" "${K_DIR}"
fi

# https://stackoverflow.com/a/39398359/1396508
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        --debug)
        DEBUG=1
        ;;
        --install)
        INSTALL=1
        PURGE=0
        ;;
        --purge)
        INSTALL=0
        PURGE=1
        ;;
        --update-start-point-only)
        UPDATE_START_POINT_ONLY=1
        ;;
        *)
        # Do whatever you want with extra options
        echo "Unknown option '$key'"
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done

function install_vagrant_plugins {
    command -v vagrant >/dev/null 2>&1 || (echo "Install vagrant dummy" ; return 1)

    echo "vagrant plugins : $(vagrant plugin list)"
    vagrant plugin update && echo "updated all vagrant plugins prior to installation"

    local plugins=(
        'vagrant-proxyconf'
        'vagrant-timezone'
        'vagrant-cachier'
        'vagrant-hosts'
        'sahara'
        'vagrant-triggers'
    )
    local plugin

    echo "###########################"
    for plugin in ${plugins[@]}; do
        vagrant plugin install ${plugin} && echo "${plugin} installed"
    done
    echo "###########################"
}

install_wakatime() {
    sudo -EH pip install wakatime --upgrade && echo "wakatime installed/upgraded"
    install_wakatime_bash
}

install_wakatime_bash() {
    cwd=${PWD} && pushd $HOME
    bw_dir=$PWD/.bash-wakatime
    bw_script=$bw_dir/bash-wakatime.sh
    bw_config=$HOME/.wakatime.cfg

    if [ ! -d $bw_dir ]; then
        git clone https://github.com/gjsheep/bash-wakatime.git $bw_dir --depth 1
    else
        pushd $bw_dir
        git fetch --all && git rebase origin/master
        popd
    fi

    if ! grep -q "source $bw_script" "$HOME/.bashrc"; then
          echo "source $bw_script" >> $HOME/.bashrc
      else
          echo "source $bw_script already in $HOME/.bashrc"
    fi

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

    cd $cwd
}

install_proxy() {
    echo "Installing proxy"

    local proxy_local=${PWD}/proxy.crap
    local proxy_target=$HOME/.config/proxy.sh

    if [ ! -f ${proxy_local} ]; then
        echo "Seems like there's no proxy here or there is no $proxy_local file with all the settings"

        echo "File should present following structure::

        export http_proxy={your_proxy}
        export https_proxy={your_proxy}
        export ftp_proxy={your_proxy}
        export socks_proxy={your_proxy}
        export no_proxy=127.0.0.1,localhost,{rest}

        export HTTP_PROXY=$http_proxy
        export HTTPS_PROXY=$https_proxy
        export FTS_PROXY=$fts_proxy
        export NO_PROXY=$no_proxy

        "

        return 1
    fi

   echo "Ehh....damn that"

   cp -f ${proxy_local} ${proxy_target} && echo "Copied proxy over to ${proxy_target}"
   if ! grep -q "source ${proxy_target}" "$HOME/.bashrc"; then
      echo "source ${proxy_target}" >> $HOME/.bashrc
   else
      echo "source ${proxy_target} already in $HOME/.bashrc"
   fi

   source ${proxy_target}
   proxy_chains && echo "Successfully applied proxy"
}

install_docker() {
    echo "Installing docker"

    # first check if docker installed and if we want to remove
    # it first
    if is_app_installed docker; then
        echo -n "Docker already installed, remove [y/n]"
        read uninstall_docker

        if [ "${uninstall_docker}" == "y" ]; then
            sudo apt-get remove docker-ce docker docker-engine docker.io -y -qq
        else
            return 1
        fi
    fi

    if ! is_app_installed docker; then
        local gist="kornicameister/9d102653522ab8c85ed6a6f4cc18d58a"
        wget -O - https://gist.githubusercontent.com/$gist/raw/install.sh | bash

        sudo systemctl enable docker
        sudo systemctl restart docker

        sudo groupadd docker || true
        sudo usermod -aG docker $USER
    fi
}

install_nnn() {
    # https://github.com/jarun/nnn
    echo "Installing nnn"
    sudo add-apt-repository ppa:twodopeshaggy/jarun -yu
    sudo apt-get install nnn
}

enable_bash_completion() {
    if ! grep -q "/etc/bash_completion" "${HOME}/.bashrc"; then
        if [ -f "/etc/bash_completion" ]; then
            echo ". /etc/bash_completion" >> "${HOME}/.bashrc"
        fi
    fi
}

enable_start_point() {
    rm -rf "${K_START_POINT}" && echo "Removed old ${K_START_POINT}"

    for binding in $K_DIR/b_* ; do
        echo "Adding binding ${binding}"
        echo ". ${binding}" >> "${K_START_POINT}"
    done

    if ! grep -q "${K_START_POINT}" "$HOME/.bashrc"; then
        echo ". ${K_START_POINT}" >> "$HOME/.bashrc"
    else
        echo "${K_START_POINT} already in bashrc"
    fi
}

if [ $DEBUG -eq 1 ]; then
    _XTRACE_KOLLA=$(set +o | grep xtrace)
    set -o xtrace
    _ERREXIT_KOLLA=$(set +o | grep errexit)
    set -o errexit
fi

if [ $INSTALL -eq 1 ]; then
    echo "Installing kornicameister stuff"

    if [ ! -d "${K_DIR}" ]; then
        mkdir -p "${K_DIR}" && echo "A place of K [${K_DIR}] has been created"
    fi
    if [ ! -f "${HOME}/.bashrc" ]; then
        touch "${HOME}/.bashrc"
    else
        if [ ! -f "${HOME}/.bashrc.copy" ]; then
            cp "${HOME}/.bashrc" "${HOME}/.bashrc.copy"
        fi
    fi

    if [ $UPDATE_START_POINT_ONLY -eq 0 ]; then

        sudo true && echo "sudo granted, it is needed"
        sudo apt-get update -qq && echo "System packages list updated"

        install_prompt proxy install_proxy
        install_prompt tools install_tools
        install_prompt dev install_dev
        install_prompt other install_other
        install_prompt os_specific install_os

        install_prompt wakatime install_wakatime
        install_prompt vagrant_plugins install_vagrant_plugins
        install_prompt docker install_docker
        install_prompt nnn install_nnn
    fi

    echo "Updating ${K_START_POINT}" && enable_start_point
    echo "Enable bash completion" && enable_bash_completion
fi
if [ $PURGE -eq 1 ]; then
    echo "Damn...already removing all that"
    echo "Haha...not implemented"
fi

if [ $DEBUG -eq 1 ]; then
    $_ERREXIT_KOLLA
    $_XTRACE_KOLLA
fi
