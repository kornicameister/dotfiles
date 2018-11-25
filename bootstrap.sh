#!/bin/bash

if lsb_release -a | grep elementary; then
    source ${TOP_DIR}/os/elementary.sh "${TOP_DIR}" "${K_DIR}"
fi


