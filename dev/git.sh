
#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

GIT_PROMPT_BINDING="${K_DIR}/b_git_prompt.sh"
GLOBAL_GITIGNORE="${K_DIR}/gitignore"

install_dev_git() {
    if ! is_app_installed git; then
        echo "Installing git"
        _install_git
    fi
    _install_git_extras
}

_install_git() {
    sudo add-apt-repository ppa:git-core/ppa -y
    sudo apt-get update -qq
    sudo apt-get install git -y -qq
}

_install_git_extras() {
    # tj/git-extras
    if ! is_app_installed git-extras; then
        local proxyFlag=""
        if [[ -n $http_proxy ]] || [[ -n $HTTP_PROXY ]]; then
            proxyFlag="-x ${http_proxy:-$HTTP_PROXY}";
        fi
        curl "${proxyFlag}" -sSL http://git.io/git-extras-setup | sudo bash /dev/stdin
    else
        sudo -EH git-extras update
    fi
}

