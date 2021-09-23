#!/bin/sh

install_packages() {
  _install_brew

  brew update
  brew upgrade

  _install_packages

  brew clean
}

_install_brew() {
  if ! command -v brew >/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
  fi
}

_install_packages() {
  brew bundle --file Brewfile

  pipx ensurepath
  pipx install \
    httpie \
    yamllint \
    wakatime \
    pywal
}

if ((SHLVL > 1)); then
  install_packages
fi
