#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

install_spotify() {
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

    sudo apt-get update -qq
    sudo apt-get install spotify-client -y -qq
}

