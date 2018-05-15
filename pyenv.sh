# load pyenv
export PYENV_ROOT=$(realpath "$HOME/.pyenv")
export PATH="$PYENV_ROOT/bin:$PATH"

[ ! -d $(pyenv root)/plugins/pyenv-update ] && git clone git://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
[ ! -d $(pyenv root)/plugins/pyenv-virtualenv ] && git clone git://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-virtualenv
[ ! -d $(pyenv root)/plugins/pyenv-ccache ] && git clone git://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-ccache

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

