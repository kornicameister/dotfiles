#!/bin/bash

# Prevent resourcing
[[ -z "$_K_UTILS" ]] || return 0
declare -r -g _K_UTILS=1

# copied from devstack-dev/devstack
die() {
    local exitcode=$?
    set +o xtrace
    local line=$1; shift

    if [ $exitcode == 0 ]; then
        exitcode=1
    fi

    backtrace 2

    err $line "$*"

    sleep 1
    exit $exitcode
}

backtrace() {
    local level=$1
    local deep
    deep=$((${#BASH_SOURCE[@]} - 1))
    echo "[Call Trace]"
    while [ $level -le $deep ]; do
        echo "${BASH_SOURCE[$deep]}:${BASH_LINENO[$deep-1]}:${FUNCNAME[$deep-1]}"
        deep=$((deep - 1))
    done
}

err() {
    local exitcode=$?
    local xtrace
    xtrace=$(set +o | grep xtrace)
    set +o xtrace
    local msg="[ERROR] ${BASH_SOURCE[2]}:$1 $2"
    echo $msg 1>&2;
    if [[ -n ${LOGDIR} ]]; then
        echo $msg >> "${LOGDIR}/error.log"
    fi
    $xtrace
    return $exitcode
}
# copied from devstack-dev/devstack

install_prompt() {
    local what=$1
    local fn=$2
    local val

    # remove two required arguments and use the rest to call passed function
    shift && shift

    echo -n "Install $what [y/n]: " ; read answer

    if [ "$answer" == "y" ]; then
        ($fn "$@")
        val=0
    else
        echo "Skipping ${what} installation, answer was ${answer}"
        val=1
    fi

    return $val
}
