
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
    _install_git_prompt
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

_install_git_prompt() {
    echo "Installing git-prompt"

    local repo=git@github.com:magicmonty/bash-git-prompt.git
    local target_dir="${K_DIR}/bash-git-prompt"

    if [ ! -d $target_dir ]; then
        git clone "${repo}" "${target_dir}" --depth=1
    else
        cd $target_dir
        git reset --hard HEAD
        git fetch --all
        git rebase origin/master
    fi

    rm -rf "${GIT_PROMPT_BINDING}"
    cat >"${GIT_PROMPT_BINDING}" <<EOL

GIT_PROMPT_ONLY_IN_REPO=0
GIT_PROMPT_SHOW_UPSTREAM=1
GIT_PROMPT_THEME=Single_line_Solarized_Lamda

. $target_dir/gitprompt.sh

EOL
}


