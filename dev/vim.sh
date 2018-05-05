#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

source "${TOP_DIR}/utils.sh"

install_dev_vim() {
    echo "Installing vim"
    _remove_system_vim
    _install_vim
}

_remove_system_vim() {
    vim_apt_pkgs="vim vim-runtime gvim"
    sudo -EH apt-get purge $vim_apt_pkgs -y -qq && echo "Uninstalled older vim: $vim_apt_pkgs " || true
}

_install_vim() {
    local vim_deps=""

    vim_deps="libncurses5-dev libgnome2-dev
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev
    libx11-dev libxpm-dev libxt-dev python-dev python3-dev
    lua5.1 lua5.1-dev libperl-dev git"
    sudo -EH apt-get install $vim_deps -y -qq && echo "Installed vim dependencies: $vim_deps"

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

    local pkg_name="k_vim"
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

