#!/bin/bash

TOP_DIR="${1}"
K_DIR="${2}"

RVM_VERSION="stable"
RUBY_VERSION="ruby-head"

install_dev_ruby() {
    _install_keys
    _install_rvm
    _install_ruby
}

_install_keys() {
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
}

_install_rvm() {
    curl -sSL https://get.rvm.io | bash -s "${RVM_VERSION}"
}

_install_ruby() {
    set -i
    (
        source "${HOME}/.bashrc";
        rvm install ${RUBY_VERSION};
        rvm alias create default ${RUBY_VERSION}
    )
    set +i
}
