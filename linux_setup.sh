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

if [ $1 == "--debug" ]; then
   set -x
fi

install_tig
install_fzf
install_vimplug
install_my_functions

# TODO(trebskit) installing bash aliases would be nice to have

if [ $1 == "--debug" ]; then
    set +x
fi
