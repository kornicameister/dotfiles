#!/bin/bash

if ! command -v pyenv >/dev/null 2>&1; then
  pyenv="${HOME}/.pyenv/bin/pyenv"
else
  pyenv=$(which pyenv)
fi
if ! command -v nodenv >/dev/null 2>&1; then
  nodenv="${HOME}/.nodenv/bin/nodenv"
else
  nodenv=$(which nodenv)
fi
if ! command -v goenv >/dev/null 2>&1; then
  goenv="${HOME}/.goenv/bin/goenv"
else
  goenv=$(which goenv)
fi

PYENV_ROOT=$($pyenv root)
NODENV_ROOT=$($nodenv root)
GOENV_ROOT=$($goenv root)

install_envs() (

if [ ! -f "${PYENV_ROOT}/version" ]; then
      echo "Installing latest Python"

      for py_major in {2,3}; do
        $pyenv latest install -s "${py_major}"
        "$(pyenv root)/versions/$(pyenv latest --print-installed $py_major)/bin/pip" install -r "${PWD}/python-system-requirements.txt"
      done
      $pyenv global "$($pyenv latest --print-installed 3)"

  else
      echo "pyenv already has system version set at it is $(cat "${PYENV_ROOT}/version")"
  fi

  if [ ! -f "${NODENV_ROOT}/version" ]; then
      echo "Installing latest Node"

      $nodenv latest install -s 12
      $nodenv global "$($nodenv latest --print-installed 12)"
  else
      echo "nodenv already has system version set at it is $(cat "${NODENV_ROOT}/version")"
  fi

  if [ ! -f "${GOENV_ROOT}/version" ]; then
      echo "Installing latest GO"

      $goenv latest install -s 1
      $goenv global "$($goenv latest --print-installed 1)"
  else
      echo "goenv already has system version set at it is $(cat "${GOENV_ROOT}/version")"
  fi

)

install_requirements() (
  for py_major in {2,3}; do
      if [ ! -d "${PYENV_ROOT}/versions/neovim${py_major}" ]; then
          echo "Initializing neovim setup for Python ${py_major}"
          $pyenv virtualenv "$($pyenv latest --print ${py_major})" "neovim${py_major}"
          "${PYENV_ROOT}/versions/neovim${py_major}/bin/pip" install -r ./neovim-requirements.txt
      else
          echo "${PYENV_ROOT}/versions/neovim${py_major} venv already exists"
      fi
      $pyenv virtualenvs | grep "neovim${py_major}"
  done

  $nodenv exec npm install -g neovim typescript prettier

  $pyenv rehash
  $nodenv rehash
)

(
  install_envs;
  install_requirements;
)
