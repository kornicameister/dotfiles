#!/bin/bash

set -e

info () {
  printf "\\r  [ \033[00;34m..\033[0m ] %s\n" "${1}"
}

user () {
  printf "\\r  [ \033[0;33m??\033[0m ] %s\n" "${1}"
}

success () {
  printf "\\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "${1}"
}

fail () {
  printf "\\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "${1}"
  echo ''
  exit 666
}

validate_bin_accessible() {
  bins_to_check=(
    nvim
    docker
    docker-compose
    snap
    git
    git-lfs
    zsh
    fzf
    pyenv
    nodenv
    python2
    python3
    purge-old-kernels
    terminator
    git-extras
    tig
    http
    tree
    aria2
    google-chrome-unstable
    firefox
    brave-browser-beta
  );

  for bin in "${bins_to_check[@]}"; do
    if command -v "${bin}" >/dev/null 2>&1; then
      success "${bin} is accessible via $(whereis "${bin}")"
    else
      fail "${bin} is not accessible"
    fi
  done
}

info 'Validating installation'
validate_bin_accessible
