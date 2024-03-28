#!/usr/bin/env bash

# installs dotfiles using remote procedure
# into the $HOME/.dotfiles directory

SOURCE="https://github.com/kornicameister/dotfiles"
TARGET="$HOME/.dotfiles"

is_executable() {
  type "$1" > /dev/null 2>&1
}

if is_executable "git"; then
  CMD="git clone $SOURCE $TARGET"
else
  echo "Installation without git is not possible";
  exit 1;
fi

echo "Installing dotfiles..."
mkdir -p "$TARGET"
eval "$CMD"
pushd "${TARGET}"
./install. # add all arguments in here for later 
popd
