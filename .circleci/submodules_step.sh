#!/bin/sh

mods_done=$(git diff --stat --name-only HEAD..master | grep -cE '\.gitmodules|dependencies\/')

echo "Modifications done to submodules is ${mods_done}"

[ "${mods_done}" -le 1 ] && {
  git submodule update --init --recursive --recommend-shallow;
  git submodule status
} || echo "Nothing about submodules have changed, skipping"
