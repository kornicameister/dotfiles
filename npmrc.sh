# the script dynamically configures npmrc by checking
# if proxy is enabled in the system

(command -v npm >/dev/null 2>&1) && (

    # clear any changes that might have been there
    # but are not submitted in here
    [ -f $HOME/.npmrc ] && rm -rf $HOME/.npmrc

    if [[ -n "${http_proxy}" || -n "${HTTP_PROXY}" ]]; then
        npm config set proxy "${HTTP_PROXY:-${http_proxy}}"
        npm config set registry "http://registry.npmjs.org/"
        npm config set strict-ssl false
    fi

    npm config set send-metrics true
    npm config set loglevel "http"

)
