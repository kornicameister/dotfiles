#!/bin/bash

TOP_DIR=${1}
K_DIR=${2}

GET_PIP="${K_DIR}/get_pip.py"
V_WRAPPER_BINDING="${K_DIR}/b_vwrapper.sh"
V_WRAPPER_HOME="${HOME}/VirtualEnvs"

source ${TOP_DIR}/utils.sh

install_dev_python() {
    if ! is_app_installed python; then
        echo "There is no python in here, installation of it is not supported"
        return 1
    fi
    _pip
    _virtualenvwrapper
}

_pip() {
    local get_pip_url="https://bootstrap.pypa.io/get-pip.py"
    rm -f "${GET_PIP}" && wget -O "${GET_PIP}" "${get_pip_url}"
    python "${GET_PIP}" && rm -f "${GET_PIP}"
}

_virtualenvwrapper() {
    if ! is_app_installed pip; then
        echo "Damn it...where is pip"
        return 1
    fi
    sudo -EH pip install virtualenvwrapper -U

    local path
    path=`whereis virtualenvwrapper | awk '{print $2}'`

    if [ ! -f "${V_WRAPPER_BINDING}" ]; then
        cat >"${V_WRAPPER_BINDING}" <<EOL
export WORKON_HOME=${V_WRAPPER_HOME}
. ${path}
EOL
    fi
    if [ ! -f "${V_WRAPPER_HOME}" ]; then
        mkdir -p "${V_WRAPPER_HOME}"
    fi
}
