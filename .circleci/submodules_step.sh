#!/bin/bash

git fetch --all && echo "Updated to full state from remote"

mods=$(git diff --stat --name-only HEAD..master)
mods_count=$(echo "${mods}" | grep -cE '\.gitmodules|dependencies\/')

echo "Mods are :: ${mods}"

(( mods_count >= 1)) && {
  git submodule update --init --recursive --recommend-shallow;
  git submodule status
} || echo "Nothing about submodules have changed, skipping"
