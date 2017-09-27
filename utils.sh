#!/bin/bash

install_prompt() {
    local what=$1
    local fn=$2
    local val

    echo -n "Install $what [y/n]: " ; read answer

    if [ "$answer" == "y" ]; then
        ($fn)
        val=0
    else
        echo "Skipping ${what} installation, answer was ${answer}"
        val=1
    fi

    return $val
}
