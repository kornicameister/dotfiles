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
  # base packages
  brew install \
    coreutils \
    moreutils \
    findutils \
    wget \
    zsh

  # development
  brew install \
    ccache \
    git \
    git-extras \
    git-lfs \
    jq \
    pipx \
    shellcheck \
    shfmt \
    svn \
    subversion \
    the_silver_searcher \
    universal-ctags \
    yq \
    lua \
    stylua \
    ruby \
    rbenv \
    exiftool
  brew install --cask gitify

  brew install --cask meld
  brew install --cask iterm2
  brew install --head luajit neovim

  # utilities
  brew install \
    aria2 \
    gnupg \
    openssh \
    htop \
    screenfetch \
    parallel

  # docker
  brew install --cask docker
  brew istall \
    ctop \
    hadolint

  # virtualbox
  brew istall --cask virtualbox

  # browsers
  brew install --cask brave-browser
  brew install --cask google-chrome
  brew install --cask firefox

  # java
  brew install --cask adoptopenjdk
  brew install maven

  # fonts
  brew tap homebrew/cask-fonts
  brew install --cask \
    font-iosevka \
    font-fontawesome \
    font-material-icons \
    font-hack-nerd-font \
    font-awesome-terminal-fonts

  # aws
  brew install awscli

  # others
  brew install --cask \
    spotity \
    signal \
    slack \
    authy

  # pipx setup
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
