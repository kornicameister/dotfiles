#!/bin/bash

# the script dynamically configures npmrc by checking
# if proxy is enabled in the system

rm -rf "${HOME}/.npmrc" && touch "${HOME}/.npmrc"

if [[ -z "${http_proxy:-''}" || -z "${HTTP_PROXY:-''}" ]]; then
    cat >>"$HOME/.npmrc" <<EOL
proxy="${HTTP_PROXY:-${http_proxy}}"
registry="http://registry.npmjs.org/"
strict-ssl=false
EOL
fi

echo "send-metrics=true" >> "${HOME}/.npmrc"
echo "loglevel=http" >> "${HOME}/.npmrc"
