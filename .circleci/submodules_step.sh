#!/bin/bash

mods=$(git diff --stat --name-only HEAD..master)
mods_count=$(echo "${mods}" | grep -cE '\.gitmodules|dependencies\/')

(( mods_count >= 1)) && {
  echo "Mods are :: ${mods}"

  git submodule update --init --recursive --recommend-shallow;
  git submodule status

} || echo "Nothing about submodules have changed, skipping"
