#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

install_chrome() {
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update -qq

    sudo apt-get install google-chrome-unstable -y -qq
}
