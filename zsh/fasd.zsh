pmodload 'editor'

cache_file="${TMPDIR:-/tmp}/fasd-cache.$UID.zsh"

if [[ "${commands[fasd]}" -nt "$cache_file" || ! -s "$cache_file"  ]]; then
  init_args=(
    zsh-hook
    zsh-ccomp
    zsh-ccomp-install
    zsh-wcomp
    zsh-wcomp-install
    posix-alias
  )
  fasd --init "$init_args[@]" >! "$cache_file" 2> /dev/null
fi

source "$cache_file"
unset cache_file init_args

# Changes the current working directory interactively.
alias j='fasd_cd -i'

# bindings
bindkey '^X^A' fasd-complete    # C-x C-a to do fasd-complete (files and directories)
bindkey '^X^F' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)
bindkey '^X^D' fasd-complete-d  # C-x C-d to do fasd-complete-d (only directories)
