# load pyenv
export PYENV_ROOT=$(realpath "$HOME/.pyenv")
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

