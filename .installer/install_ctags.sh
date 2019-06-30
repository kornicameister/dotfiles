#!/bin/bash

CTAGS_DIR="${PWD}/dependencies/ctags"

[ ! -d "${CTAGS_DIR}" ] && (
  cd "${K_DOTFILES_DIR}" || exit 2;
  git submodule update --init --recursive;
  cd ..;
)
[ ! -f "${HOME}/.gitconfig.local" ] && (
  touch "${HOME}/.gitconfig.local";
)


aptitude purge exuberant-ctags -q -y

cd "${CTAGS_DIR}" || exit 1

CURRENT_VERSION="$(git config --file "${HOME}/.gitconfig.local" --default '-1' --get ctags.version)"
REPO_VERSION="$(git log -n 1 --format=oneline | awk '{print $1}')"

if [[ "${CURRENT_VERSION}" == "${REPO_VERSION}" ]]; then
  echo "No need to install ctags again"
else
    ./autogen.sh;
    ./configure --prefix="${HOME}/.local";
    make clean;
    make;
    make install;
    git config --file="${HOME}/.gitconfig.local" ctags.version "${REPO_VERSION}";
fi
cd ..
