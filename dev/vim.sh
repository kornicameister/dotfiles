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
    vim_apt_pkgs="vim vim-runtime gvim vim-tiny vim-common vim-gui-common vim-nox"
    sudo -EH apt-get purge $vim_apt_pkgs -y -qq && echo "Uninstalled older vim: $vim_apt_pkgs " || true
}

_install_vim() {
    local vim_deps=""

    vim_deps="libncurses5-dev libgnome2-dev
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev
    libx11-dev libxpm-dev libxt-dev python-dev python3-dev python3-pip
    lua5.1 lua5.1-dev libperl-dev git"
    sudo -EH apt-get install $vim_deps -y -qq && echo "Installed vim dependencies: $vim_deps"

    local vim_repo="https://github.com/vim/vim.git"
    local vim_dir=/tmp/vim

    git clone $vim_repo $vim_dir --depth 1

    # define basic details
    local pkg_name="k-vim"
    local pgk_version=$(cd $vim_dir ; git tag ; cd - >> /dev/null)

    # set all necessary flags for compilation
    local flags=""
    local python_conf_dir=""

    flags="--with-modified-by=kornicameister --with-compiledby=kornicameister"
    flags="$flags --disable-gui"

    flags="$flags --enable-multibyte"
    flags="$flags --with-features=huge"
    flags="$flags --enable-xim"
    flags="$flags --enable-fontset"

    flags="$flags --prefix=/usr/local"

    flags="$flags --enable-luainterp=no"
    flags="$flags --enable-rubyinterp=no"
    flags="$flags --enable-perlinterp=no"
    flags="$flags --enable-cscope=no"
    flags="$flags --enable-tclinterp=no"
    (command -v python3 >/dev/null 2>&1) && flags="$flags --enable-python3interp=dynamic --enable-pythoniterp=no" || flags="$flags --enable-pythoninterp=dynamic --enable-python3interp=no"

    # define checkinstall arguments
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
    ./configure $flags
    sudo -EH checkinstall $ci_args
    popd

    sudo rm -rf $vim_dir || true

    sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
    sudo update-alternatives --set editor /usr/local/bin/vim
    sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
    sudo update-alternatives --set vi /usr/local/bin/vim
}

