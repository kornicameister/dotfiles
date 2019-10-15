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

in_progress () {
  printf "\\r  [ \\033[00;34m\\u23F0\\033[0m ] %s\\r" "${1}"
}

fail () {
  printf "\\r\\033[2K  [\\033[0;31mFAIL\\033[0m] %s\\n" "${1}" >&2
  exit 666
}

exists() {
  command -v "$1" &> /dev/null;
}

retry() {
  local n=1
  local max=50
  local delay=2

  while true; do
    if "$@"; then
      break
    else
      if [[ $n -lt $max ]]; then
        ((n++))
        sleep $delay;
      else
        fail "The command has failed after $n attempts."
      fi
    fi
  done
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
    # gotta have python dawg
    python2
    python3
    # node should be provided as well
    node
    # do not forget golang
    go
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
    htop
    jq
  );

  for bin in "${bins_to_check[@]}"; do
    in_progress "${bin}"
    if retry exists "${bin}"; then
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
    goenv
    jenv
    fzf
  );

  for bin in "${bins_to_check[@]}"; do
    bin_path="${HOME}/.${bin}/bin/${bin}"

    in_progress "${bin_path}"
    if [[ -s "${bin_path}" ]]; then
      v_out=$($bin_path --version | tr "'${bin}'" ' ' | sed -e 's/^[[:space:]]*//')
      success "${bin} is accessible via ${bin_path} with version ${v_out}"
    else
      fail "${bin} is not accessible"
    fi

    in_progress "${bin}"
    if retry exists "${bin}"; then
      success "${bin} is accessible via $(whereis "${bin}")"
    else
      fail "${bin} is not accessible"
    fi
  done
)

validate_pyenv() (
  if [[ ! -s "${HOME}/.pyenv" ]]; then
    fail "Failed to locate pyenv directory in \$HOME"
  else
    success "pyenv directory set"

    local venvs_to_check
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

    zsh -mil -c "pyenv doctor"
    if [[ ! -f "${HOME}/.pyenv/version" ]]; then
      fail "pyenv did not set global system version"
    fi
  fi
)

validate_nodenv() (
  if [[ ! -s "${HOME}/.nodenv" ]]; then
    fail "Failed to locate nodenv directory in \$HOME"
  else
    success "nodenv directory set"
    zsh -mil -c "npx -p @nodenv/nodenv-installer nodenv-doctor"
    if [[ ! -f "${HOME}/.nodenv/version" ]]; then
      fail "nodenv did not set global system version"
    fi
  fi
)

validate_goenv() (
  if [[ ! -s "${HOME}/.goenv" ]]; then
    fail "Failed to locate goenv directory in \$HOME"
  else
    success "goenv directory set"
    if [[ ! -f "${HOME}/.goenv/version" ]]; then
      fail "goenv did not set global system version"
    fi
  fi
)

validate_jenv() (
  if [[ ! -s "${HOME}/.jenv" ]]; then
    fail "Failed to locate jenv directory in \$HOME"
  else
    success "jenv directory set"
    jenv doctor
    if [[ ! -f "${HOME}/.jenv/version" ]]; then
      fail "jenv did not set global system version"
    fi
  fi
)

validate_git_config() {
  if [[ ! -f "${HOME}/.gitconfig.local" ]]; then
    fail "Local git configuration not set";
  else
    success "git configured"
  fi
}

validate_wakatime_config() {
  if [[ ! -f "${HOME}/.wakatime.cfg" ]]; then
    fail "Local wakatime configuration not set";
  else
    success "wakatime configured"
  fi
}

validate_docker() (
  docker info
  docker version
  
  local helloWorld
  helloWorld=$(docker run hello-world)
  if [[ "${helloWorld}" == *"Hello from Docker!"* ]]; then
    success "docker accessible"
  else
    fail "docker does not seem to work"
  fi

)

info 'Validating installation'
(
  info "Path is [ $(echo "${PATH}" | tr ':' '\t\r\n') ]"
  validate_git_config;
  validate_wakatime_config;
  validate_bin_accessible;
  validate_interactive_bins;
  validate_pyenv;
  validate_nodenv;
  validate_goenv;
  validate_jenv;
  validate_docker;
)
info 'Validation successful'

