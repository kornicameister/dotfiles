#!/bin/bash

PROXY_CONF=$HOME/.config/proxy.sh
PROXY_BACKUP=$PROXY_CONF.backup

docker_gc() {
    docker run --rm \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /etc:/etc:ro spotify/docker-gc
}

# git related

# Public: Removes all .orig files after rebase/merge/cherry-pick ops
#
# No args
#
# Examples
#   git_clean_orig
#
# Returns
#   null
git_clean_orig() {
    find $(pwd) -type f -name '*.orig' -print0 | xargs -0 rm -fv || true
}

replace_in_all() {
    local expr_what=$1
    local expr_to=$2
    local find_pattern=${3:-*}
    local find_where=${4:-.}

    local files
    files=$(find "${find_where}" -type f -name "${find_pattern}" -exec grep -inHl --binary-files=without-match "${expr_what}" {} /dev/null \;)

    if [ -z $files ]; then
        echo "Found $files to replace $expr_what"
        sed -e "s/${expr_what}/${expr_to}/g" -i ${files}
    fi
}

proxy_freedom() {
    echo "Unsetting the proxy in proxy"

    if is_app_installed docker; then
        echo "Removing proxy from docker"
        if [ -f /etc/systemd/system/docker.service.d/proxy.conf ]; then
            sudo rm -rf /etc/systemd/system/docker.service.d/proxy.conf
            sudo systemctl daemon-reload && echo "reloaded systemctl"
            sudo systemctl restart docker && echo "restarted docker without proxy"
        else
            echo "Sneaky bastard, there's no proxy for docker anymore \m/"
        fi
    fi

    if is_app_installed git; then
        echo "Removing proxy from git"
        git config --global --unset http.proxy
        git config --global --unset https.proxy
    fi

    if is_app_installed npm; then
        echo "Removing proxy from npm"
        npm config delete proxy
        npm config delete https-proxy
        npm config set registry $(npm config get registry | sed 's|http|https|g')
    fi

    if [ -f $HOME/.config/proxy.sh ]; then
        echo "Backing up proxy config to $PROXY_BACKUP"
        mv -f $PROXY_CONF $PROXY_BACKUP
        touch $PROXY_CONF
    fi

    if [ -f $HOME/.wakatime.cfg ]; then
        echo "Removing proxy from wakatime"
        section="settings"
        option="proxy"
        file="$HOME/.wakatime.cfg"
        sed -i -e "/^\[$section\]/,/^\[.*\]/ { /^$option[ \t]*=/ d; }" "$file"
    fi

    unset $(env | grep proxy | tr '=' ' ' | awk '{print $1}') && echo "Removed proxy from current environment"

    source $HOME/.bashrc && echo "Resourced myself"
}

proxy_chains() {
    echo "Restoring proxy settings"

    if [ ! -f $PROXY_BACKUP ]; then
        echo "Is proxy backup missing at $PROXY_BACKUP ???"
    else
        echo "Restoring proxy from $PROXY_BACKUP"
        mv -f $PROXY_BACKUP $PROXY_CONF
        source $PROXY_CONF
    fi

    if is_app_installed docker; then
        echo "Applying proxy for docker"
        sudo touch /etc/systemd/system/docker.service.d/proxy.conf
        sudo chown $USER /etc/systemd/system/docker.service.d/proxy.conf
echo "docker_proxy" && cat > /etc/systemd/system/docker.service.d/proxy.conf << EOF
[Service]
Environment="HTTP_PROXY=$http_proxy"
Environment="HTTPS_PROXY=$http_proxy"
EOF
        sudo systemctl daemon-reload && echo "reloaded systemctl"
        sudo systemctl restart docker && echo "restarted docker with proxy"
    fi

    if is_app_installed git; then
        echo "Applygin proxy for git"
        git config --global http.proxy $http_proxy
        git config --global https.proxy $http_proxy
    fi

    if is_app_installed npm; then
        echo "Removing proxy from npm"
        npm config set proxy $http_proxy
        npm config set https-proxy $https_proxy
        npm config set registry $(npm config get registry | sed 's|https|http|g')
    fi

    if [ -f $HOME/.wakatime.cfg ]; then
        echo "Setting proxy in wakatime"
        section="settings"
        option="proxy"
        file="$HOME/.wakatime.cfg"
        value=$http_proxy
        sed -i -e "/^\[$section\]/ a\\
$option = $value
" "$file"
    fi

    source $HOME/.bashrc && echo "Resourced myself"
}

is_app_installed() {
    local what=$1
    command -v ${what} >/dev/null 2>&1 || return 1
    return 0
}

# tox utilities
tox_all() {
    tox -a | head -n $(((tox -a | wc -l)-1)) | tr '\n' ',' | xargs -t tox "$@" -e
}

install_node_package() {
    local pkg=$1
    local in_system=$(npm list --global | grep ${pkg})
    if [[ "${in_system}" ==  *"${pkg}"* ]] ; then
        echo "Updating ${pkg}"
        npm update --global ${pkg}
    else
        echo "Installing ${pkg}"
        npm install --global ${pkg}
    fi
}
