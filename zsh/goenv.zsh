[ $commands[goenv] ] && {
    _init_goenv() {
      unset -f goenv _goenv_chpwd_hook _init_goenv
      chpwd_functions[$chpwd_functions[(i)_goenv_chpwd_hook]]=()

      eval "$(goenv init - --no-rehash zsh)"
      export PATH="$GOROOT/bin:$PATH";
      export PATH="$GOPATH/bin:$PATH";
      export GOBIN="$GOPATH/bin";
    }

    _goenv_chpwd_hook() {
      local DIR=$PWD
      while [ "$DIR" != "/" ]; do
        if [ -f "$DIR/.python-version" ]; then
          _init_goenv
          break
        fi
        DIR=$DIR:h
      done
    }

    goenv() {
      _init_goenv
      goenv "$@"
    }

    autoload -U add-zsh-hook
    add-zsh-hook chpwd _goenv_chpwd_hook
}
