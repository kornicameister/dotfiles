#!/bin/bash

info () {
  printf "\\r  [ \\033[00;34m..\\033[0m ] %s\\n" "${1}"
}

user () {
  printf "\\r  [ \\033[0;33m??\\033[0m ] %s\\n" "${1}"
}

success () {
  printf "\\r\\033[2K  [ \\033[00;32mOK\\033[0m ] %s\\n" "${1}"
}

fail () {
  printf "\\r\\033[2K  [\\033[0;31mFAIL\\033[0m] %s\\n" "${1}"
  echo ''
  exit 666
}

validate_bin_accessible() (
  bins_to_check=(
    # founations
    nvim
    zsh
    terminator
    # containers & stuff
    docker
    docker-compose
    # git & utils
    git
    git-lfs
    git-extras
    tig
    # gotta have python dawg
    python2
    python3
    # browsers
    google-chrome-unstable
    firefox
    brave-browser-beta
    # linters matter
    shellcheck
    yamllint
    # utilities
    purge-old-kernels
    snap
    http
    tree
    aria2c
    ctags
  );
  for bin in "${bins_to_check[@]}"; do
    if command -v "${bin}" >/dev/null 2>&1; then
      success "${bin} is accessible via $(whereis "${bin}")"
    else
      fail "${bin} is not accessible"
    fi
  done
)

validate_interactive_bins() (
  bins_to_check=(
    pyenv
    nodenv
    fzf
  );

  for bin in "${bins_to_check[@]}"; do
    # first part
    bin_path="${HOME}/.${bin}/bin/${bin}"
    if [[ -s "${bin_path}" ]]; then
      v_out=$($bin_path --version | tr "'${bin}'" ' ' | sed -e 's/^[[:space:]]*//')
      success "${bin} is accessible via ${bin_path} with version ${v_out}"
    else
      fail "${bin} is not accessible"
    fi
  done
)

validate_pyenv() (
  venvs_to_check=(
    neovim2
    neovim3
  )
  for venv in "${venvs_to_check[@]}"; do
    if ! "${HOME}/.pyenv/bin/pyenv" versions | grep -q "${venv}"; then
      fail "Virtualenv ${venv} was not installed"
    else
      success "Virtualenv ${venv} is installed"
    fi
  done
)

info 'Validating installation'
(
  info "Path is [ $(echo "${PATH}" | tr ':' '\t\r\n') ]"
  validate_bin_accessible;
  validate_interactive_bins;
  validate_pyenv;
)
info 'Validation successful'

