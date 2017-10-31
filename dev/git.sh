
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
    _configure_global_gitignore
    _configure_git
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

_configure_global_gitignore() {
    rm -f "${GLOBAL_GITIGNORE}"
    cat >"${GLOBAL_GITIGNORE}" <<EOL

*.swp
*.swo

.idea/
.vscode/

.wakatime-project
.vagrant/

api-guide/build
api-ref/build
doc/build
releasenotes/build

EOL
}

_configure_git() {
    echo "Configuring git"

    git config --global url.https://github.com/.insteadof git://github.com/
    git config --global url.https://git.openstack.org/.insteadof git://git.openstack.org/
    git config --global pull.rebase true
    git config --global core.editor "vim"
    git config --global core.excludesfile "${GLOBAL_GITIGNORE}"

    echo -n "git user.email: [ENTER] "
    read git_user_email

    echo -n "git user.name: [ENTER] "
    read git_user_name

    git config --global user.email "${git_user_email}"
    git config --global user.name "${git_user_name}"
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

GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_SHOW_UPSTREAM=1
GIT_PROMPT_THEME=Solarized_Ubuntu

. $target_dir/gitprompt.sh

EOL
}


