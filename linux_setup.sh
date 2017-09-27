#!/bin/bash

TOP_DIR="${PWD}"

DEBUG=0
INSTALL=1
PURGE=0
UPDATE_START_POINT_ONLY=0

ME="${USER}"
K_DIR="${HOME}/.k_stuff"
K_START_POINT="${K_DIR}/k.sh"

source ${TOP_DIR}/globals
source ${TOP_DIR}/bash_functions
source ${TOP_DIR}/utils.sh

source ${TOP_DIR}/dev/all.sh "${TOP_DIR}" "${K_DIR}"

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

function install_tig {
    # text-mode interface for git https://github.com/jonas/tig
    echo "Insalling tig"
    sudo -EH apt-get install tig -yy -qq
}

function install_fzf {
    echo "Installing fzf"
    if [[ -d "$HOME/.fzf" ]]; then
        pushd ~/.fzf
        git fetch --all >> /dev/null
        git rebase origin/master >> /dev/null
        popd
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf &1>1 >> /dev/null
    fi
    yes | ~/.fzf/install >> /dev/null
}

function install_vim {
    local vim_deps=""
    local vim_apt_pkgs=""

    vim_deps="libncurses5-dev libgnome2-dev
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev
    libx11-dev libxpm-dev libxt-dev python-dev python3-dev
    lua5.1 lua5.1-dev libperl-dev git"
    vim_apt_pkgs="vim vim-runtime gvim"
    sudo -EH apt-get install $vim_deps -y -qq && echo "Installed vim dependencies: $vim_deps"
    sudo -EH apt-get purge $vim_apt_pkgs -y -qq && echo "Uninstalled older vim: $vim_apt_pkgs " || true

    local vim_repo="https://github.com/vim/vim.git"
    local vim_dir=/tmp/vim

    git clone $vim_repo $vim_dir --depth 1

    local python_conf_dir=""
    if is_app_installed python2.7; then
        python_conf_dir=$(whereis python2.7 | tr ' ' '\n' | grep config | head -n 1)
    elif is_app_installed python3.5; then
        echo "using python3.5 as --with-python-config-dir"
        python_conf_dir=$(whereis python3.5 | tr ' ' '\n' | grep config | head -n 1)
    fi

    local CONF_ARGS=""
    CONF_ARGS="--with-modified-by=$(whoami)"
    CONF_ARGS="$CONF_ARGS --enable-pythoninterp=yes"
    CONF_ARGS="$CONF_ARGS --with-python-config-dir=${python_conf_dir}"
    CONF_ARGS="$CONF_ARGS --disable-gui"
    CONF_ARGS="$CONF_ARGS --enable-luainterp=dynamic"
    CONF_ARGS="$CONF_ARGS --enable-rubyinterp=dynamic"
    CONF_ARGS="$CONF_ARGS --enable-perlinterp=dynamic"
    CONF_ARGS="$CONF_ARGS --enable-cscope"
    CONF_ARGS="$CONF_ARGS --enable-multibyte"
    CONF_ARGS="$CONF_ARGS --with-features=huge"
    CONF_ARGS="$CONF_ARGS --enable-xim"
    CONF_ARGS="$CONF_ARGS --enable-fontset"

    local pkg_name="vim"
    local pgk_version=$(cd $vim_dir ; git tag ; cd - >> /dev/null)

    local ci_args=""
    ci_args="$ci_args --install=yes"
    ci_args="$ci_args --type=debian"
    ci_args="$ci_args --pkgname=$pkg_name --pkgversion=$(echo ${pkg_version/v/""})"
    ci_args="$ci_args --default"

    pushd $vim_dir
    cd src
    sudo dpkg -r $pkg_name || echo "Looks like vim has been removed"
    make distclean
    ./configure
    ./configure $CONF_ARGS
    sudo -EH checkinstall $ci_args
    popd

    sudo rm -rf $vim_dir || true
}

function install_vim_python_deps {
    sudo -EH pip install jedi && echo "Installed jedi for jedi-vim"
}

function install_vimrc {
    # install vimrc
    ln -sf $(pwd)/vimrc $HOME/.vimrc
    ln -sfF $(pwd)/vim $HOME/.vim/k
}

function install_vimplug {
    echo "Installing vimplug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

function install_vim_plugins {
    vim +PlugInstall +all
}

function install_vim_stuff {
    install_vim
    install_vim_python_deps
    install_vimplug
    install_vimrc
    install_vim_plugins
}

function install_bash_functions {
    ln -sf ${PWD}/bash_functions $HOME/.kornicameister_bash_functions
    if ! grep -q "source ~/.kornicameister_bash_functions" "$HOME/.bashrc"; then
        echo "source ~/.kornicameister_bash_functions" >> $HOME/.bashrc
    else
        echo "source ~/.kornicameister_bash_functions already in $HOME/.bashrc"
    fi
}

function install_bash_aliases {
    ln -sf ${PWD}/bash_aliases $HOME/.kornicameister_bash_aliases
    if ! grep -q "source ~/.kornicameister_bash_aliases" "$HOME/.bashrc"; then
        echo "source ~/.kornicameister_bash_aliases" >> $HOME/.bashrc
    else
        echo "source ~/.kornicameister_bash_aliases already in $HOME/.bashrc"
    fi
}

function install_mdv {
    echo "Installing MDV - markdown viewer"
    sudo -EH pip install mdv --upgrade
}

function install_purge_old_kernels {
    local url="https://raw.githubusercontent.com/jarnos/bikeshed/patch-1/purge-old-kernels"
    sudo -EH curl -L -o /usr/local/bin/purge-old-kernels \
        https://raw.githubusercontent.com/jarnos/bikeshed/patch-1/purge-old-kernels \
        -z /usr/local/bin/purge-old-kernels
    sudo -EH chmod +x /usr/local/bin/purge-old-kernels
}

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

install_checkinstall() {
    # https://help.ubuntu.com/community/CheckInstall
    sudo -EH apt-get install checkinstall
}

install_wakatime() {
    sudo -EH pip install wakatime --upgrade && echo "wakatime installed/upgraded"
    install_wakatime_bash
}

install_wakatime_bash() {
    cwd=${PWD} && pushd $HOME
    bw_dir=$PWD/bash-wakatime
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
            sudo apt-get remove docker docker-engine docker.io -y -qq
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
        cat >$HOME/.bashrc <<EOL
. ${K_START_POINT}
EOL
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
    fi

    if [ $UPDATE_START_POINT_ONLY -eq 0 ]; then

        sudo true && echo "sudo granted, it is needed"
        sudo apt-get update -qq && echo "System packages list updated"

        install_prompt proxy install_proxy
        install_prompt dev install_dev

        install_prompt checkinstall install_checkinstall
        install_prompt wakatime install_wakatime
        install_prompt tig install_tig
        install_prompt fzf install_fzf
        install_prompt mdv install_mdv
        install_prompt k_bash_functions install_bash_functions
        install_prompt k_bash_aliases install_bash_aliases
        install_prompt vim install_vim_stuff
        install_prompt purge_old_kernels install_purge_old_kernels
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
