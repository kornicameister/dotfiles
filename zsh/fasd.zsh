cache_file="${TMPDIR:-/tmp}/fasd-cache.$UID.zsh"

if [[ "${commands[fasd]}" -nt "$cache_file" || ! -s "$cache_file"  ]]; then
  init_args=(
    zsh-hook
    zsh-ccomp
    zsh-ccomp-install
    zsh-wcomp
    zsh-wcomp-install
  )
  fasd --init "$init_args[@]" >! "$cache_file" 2> /dev/null
fi

source "$cache_file"
unset cache_file init_args

# Changes the current working directory interactively.
fasd_cd() {
  local fasd_ret="$(fasd -d "$@")"
  if [[ -d "$fasd_ret" ]]; then
    cd "$fasd_ret"
  else
    print "$fasd_ret"
  fi
}
alias j='fasd_cd -i'
