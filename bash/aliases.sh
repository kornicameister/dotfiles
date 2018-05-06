#!/usr/bin/env bash

# enable aliases to be sudo'ed
alias sudo='sudo '

# colored common stuff
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# pip
alias pip_glob_upgrade="pip freeze | tr '=' ' ' | awk '{print $1}' | xargs sudo -EH pip install --upgrade"
alias pip_install_os="pip install -r requirements.txt -r test-requirements.txt -c https://git.openstack.org/cgit/openstack/requirements/plain/upper-constraints.txt?master"
alias pip_upgrade_os="pip_install_os --upgrade"

# time vagrant run
alias vagrant="time vagrant"
alias vagrant_up="vagrant destroy -f && rm -rf .vagrant && vagrant up"
alias vagrant_destroy="vagrant destroy -f && rm -rf .vagrant"

# apt utilities
alias install="sudo apt install"
alias upgrade="sudo apt update ; sudo apt dist-upgrade -y; sudo apt autoremove -y ; sudo apt autoclean -y"

# bash aliases
alias ..='cd ..'         # Go up one directory
alias cd..='cd ..'       # Common misspelling for going up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias -- -='cd -'        # Go back

