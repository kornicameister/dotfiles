#!/bin/bash

TOP_DIR=${1}
K_DIR=${2}

export BASH_BINDING="${K_DIR}/b_bash.sh"

install_dev_bash() {
    rm -rf "${BASH_BINDING}"
    echo ". ${TOP_DIR}/bash/fn.sh" >> "${BASH_BINDING}"
    echo ". ${TOP_DIR}/bash/aliases.sh" >> "${BASH_BINDING}"
}
