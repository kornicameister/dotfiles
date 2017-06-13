#!/bin/bash

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

function install_vimrc {
    # install vimrc
    ln -sf $(pwd)/vimrc $HOME/.vimrc && echo "Linked $(pwd)/vimrc to $HOME/.vimrc"

    # install splitted configuration
    ln -sfF $(pwd)/vim/plugins/ $HOME/.vim/
    ln -sf $(pwd)/vim/plugins.vim $HOME/.vim/plugins.vim
}

function install_vim_stuff {
    sudo -EH pip install jedi && echo "Installed jedi for jedi-vim"
    install_vimplug && echo "Installed vimplug"
    install_vimrc
}

function install_vimplug {
    echo "Installing vimplug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

function install_my_functions {
    cp -f ./bash_functions $HOME/.kornicameister_bash_functions
    if ! grep -q "source ~/.kornicameister_bash_functions" "$HOME/.bashrc"; then
        echo "source ~/.kornicameister_bash_functions" >> $HOME/.bashrc
    else
        echo "source ~/.kornicameister_bash_functions already in $HOME/.bashrc"
    fi
}

function install_mdv {
    echo "Installing MDV - markdown viewer"
    sudo -EH pip install mdv
}

function install_purge_old_kernels {
    local url="https://raw.githubusercontent.com/jarnos/bikeshed/patch-1/purge-old-kernels"
    sudo -EH curl -L -o /usr/local/bin/purge-old-kernels \
        https://raw.githubusercontent.com/jarnos/bikeshed/patch-1/purge-old-kernels \
        -z /usr/local/bin/purge-old-kernels
    sudo -EH chmod +x /usr/local/bin/purge-old-kernels
}

function install_vagrant_plugins {
    command -v vagrant >/dev/null 2>&1 || echo "Install vagrant dummy" && return 1

    echo "vagrant plugins : $(vagrant plugin list)"
    vagrant plugin update && echo "updated all vagrant plugins prior to installation"

    local plugins=(
        'vagrant-reload'
        'vagrant-ip-show'
        'vagrant-proxyconf'
        'vagrant-timezone'
        'vagrant-cachier'
        'vagrant-hosts'
        'sahara'
    )
    local plugin

    echo "###########################"
    for plugin in ${plugins[@]}; do
        vagrant plugin install ${plugin} && echo "${plugin} installed"
    done
    echo "###########################"
}

if [ $1 == "--debug" ]; then
   set -x
fi

install_tig
install_fzf
install_mdv
install_my_functions
install_vim_stuff
install_purge_old_kernels
install_vagrant_plugins

# TODO(trebskit) installing bash aliases would be nice to have

if [ $1 == "--debug" ]; then
    set +x
fi
