#!/bin/bash

_XTRACE_KOLLA=$(set +o | grep xtrace)
set -o xtrace
_ERREXIT_KOLLA=$(set +o | grep errexit)
set -o errexit

source ${PWD}/globals
source ${PWD}/bash_functions

DEBUG=0
SKIP_PROXY=0

# https://stackoverflow.com/a/39398359/1396508
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        --skip-proxy)
        SKIP_PROXY=1
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
    local vim_dir=$HOME/vim

    if [ ! -d $vim_dir ]; then
        git clone $vim_repo $vim_dir --depth 1
    else
        pushd $vim_dir
        git fetch --all
        git reset --hard origin/master
        git rebase origin/master
        popd
    fi

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
    make distclean && ./configure $CONF_ARGS && sudo -EH checkinstall $ci_args
    popd
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

install_checkinstall {
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

    if [ $SKIP_PROXY -eq 1 ]; then
        echo "Skipping proxy setup..."
        return
    fi

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

configure_git() {
    if is_app_installed git; then
        git config --global url.https://github.com/.insteadof git://github.com/
        git config --global url.https://git.openstack.org/.insteadof git://git.openstack.org/
        git config --global pull.rebase true
    fi
}

install_proxy
configure_git
install_checkinstall
install_wakatime
install_tig
install_fzf
install_mdv
install_bash_functions
install_bash_aliases
install_vim_stuff
install_purge_old_kernels
install_vagrant_plugins

$_ERREXIT_KOLLA
$_XTRACE_KOLLA
