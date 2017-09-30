#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

source "${TOP_DIR}/utils.sh"

install_dev_travis() {
    # requires that ruby installation has
    # been executed or completed
    if [ -z "${RVM_BINDING}" ] || [ ! -f "${RVM_BINDING}" ]; then
        die "rvm installation not done"
    else
        set -i
        (
            source "${RVM_BINDING}";
            rvm use default;
            gem install travis -v 1.8.8 --no-rdoc --no-ri;
            yes 'y' | travis
        )
        set +i
   fi
}
