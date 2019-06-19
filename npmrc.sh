#!/bin/bash

# the script dynamically configures npmrc by checking
# if proxy is enabled in the system

rm -rf "${HOME}/.npmrc" && touch "${HOME}/.npmrc"
proxy_val="${HTTP_PROXY:-${http_proxy:-""}}"

if [[ -n "${proxy_val}" ]]; then
    cat >>"$HOME/.npmrc" <<EOL
proxy="${proxy_val}"
registry="http://registry.npmjs.org/"
strict-ssl=false
EOL
fi

echo "send-metrics=true" >> "${HOME}/.npmrc"
echo "loglevel=http" >> "${HOME}/.npmrc"
