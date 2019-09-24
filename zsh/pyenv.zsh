[ $commands[pyenv] ] && {
    _init_pyenv() {
      unset -f pyenv _pyenv_chpwd_hook _init_pyenv
      chpwd_functions[$chpwd_functions[(i)_pyenv_chpwd_hook]]=()

      eval "$(pyenv init - --no-rehash zsh)"
      eval "$(pyenv virtualenv-init -)"
    }

    _pyenv_chpwd_hook() {
      local DIR=$PWD
      while [ "$DIR" != "/" ]; do
        if [ -f "$DIR/.python-version" ]; then
          _init_pyenv
          break
        fi
        DIR=$DIR:h
      done
    }

    pyenv() {
      _init_pyenv
      pyenv "$@"
    }

    autoload -U add-zsh-hook
    add-zsh-hook chpwd _pyenv_chpwd_hook
}
