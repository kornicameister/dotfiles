#!/bin/bash

export NVM_DIR=$(realpath "$HOME/.nvm")
export NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist

[ -s "${NVM_DIR}/nvm.sh" ] && source "${NVM_DIR}/nvm.sh"  # This loads nvm
[ -s "${NVM_DIR}/bash_completion" ] && source "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion

