#!/usr/bin/env bash

# load pyenv
PYENV_ROOT=$(realpath "$HOME/.pyenv")

export PYENV_ROOT
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

