[ $commands[nodenv] ] && {
    _init_nodenv() {
      unset -f nodenv _nodenv_chpwd_hook _init_nodenv
      chpwd_functions[$chpwd_functions[(i)_nodenv_chpwd_hook]]=()

      eval "$(nodenv init - --no-rehash zsh)"
    }

    _nodenv_chpwd_hook() {
      local DIR=$PWD
      while [ "$DIR" != "/" ]; do
        if [ -f "$DIR/.python-version" ]; then
          _init_nodenv
          break
        fi
        DIR=$DIR:h
      done
    }

    nodenv() {
      _init_nodenv
      nodenv "$@"
    }

    autoload -U add-zsh-hook
    add-zsh-hook chpwd _nodenv_chpwd_hook
}
