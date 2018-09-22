#!/bin/bash

source ${TOP_DIR}/dev/all.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/other/all.sh "${TOP_DIR}" "${K_DIR}"
source ${TOP_DIR}/tools/all.sh  "${TOP_DIR}" "${K_DIR}"

if lsb_release -a | grep elementary; then
    source ${TOP_DIR}/os/elementary.sh "${TOP_DIR}" "${K_DIR}"
fi


