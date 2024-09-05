#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASEDIR}/utils.sh"

configure_git() {
  local git_username=""
  local git_password=""
  local git_email=""
  local gpg_full_name=""
  local gpg_passphrase=""
  local force="no"
  local reconfiguring
  local icon="[  ]"
  local ssh_keyname="github"

  local _gpg
  if [[ "$(uname)" == "Darwin" ]]; then
    if ! command -v gpg >/dev/null; then
      log_die "brew install gnupg" "${icon}"
    fi
    _gpg="gpg"
  else
    _gpg="gpg2"
  fi

  while [[ $# -gt 0 ]]; do
    arg="${1}"
    case "${arg}" in
    --git-username)
      git_username="${2}"
      shift
      shift
      ;;
    --git-password)
      git_password="${2}"
      shift
      shift
      ;;
    --git-email)
      git_email="${2}"
      shift
      shift
      ;;
    --gpg-fullname)
      gpg_full_name="${2}"
      shift
      shift
      ;;
    --gpg-passphrase)
      gpg_passphrase="${2}"
      shift
      shift
      ;;
    --force)
      force="yes"
      shift
      shift
      ;;
    *)
      # whatever
      shift
      shift
      ;;
    esac
  done

  [ "${force}" == "yes" ] && {
    rm -rf "${HOME}/.gitconfig.local"
    find "${HOME}/.ssh/" -name "${ssh_keyname}*" -exec rm -rf {} \;
    reconfiguring="yes"
  }

  chown -R "$(whoami)" ~/.gnupg/
  find ~/.gnupg -type f -exec chmod 600 {} \;
  find ~/.gnupg -type d -exec chmod 700 {} \;

  if [ ! -f "${HOME}/.gitconfig.local" ]; then
    [ "${reconfiguring}" != "yes" ] && log_info "Git profile not yet configured" "${icon}"
    if [ -z "${git_username}" ]; then
      log_die "--username must be set" "${icon}" 3
    fi
    if [ -z "${git_password}" ]; then
      log_die "--password must be set" "${icon}" 3
    fi
    if [ -z "${git_email}" ]; then
      log_die "--email must be set" "${icon}" 3
    fi
    if [ -z "${gpg_full_name}" ]; then
      log_die "--gpg-fullname must be set" "${icon}" 3
    fi
    if [ -z "${gpg_passphrase}" ]; then
      log_die "--gpg-passphrase must be set" "${icon}" 3
    fi

    # 1. generate ssh key
    # gen_ssh_key "${ssh_keyname}" "${git_password}" "${git_username}@$(hostname)"
    log_done ".ssh/${ssh_keyname} configured" "${icon}"

    key_type="rsa"
    key_strength=4096
    key_valid_for_years=1
    expire_date="$(date -v +"${key_valid_for_years}"y +"%Y-%m-%d")"
    key_config=$(mktemp)

    # 2. generating GPK key to sign the commits
    cat >>"${key_config}" <<EOF
Key-Type: ${key_type}
Key-Length: ${key_strength}
Name-Real: ${gpg_full_name}
Name-Comment: ${git_username} GPG key generated with dotfiles [${expire_date}]
Name-Email: ${git_email}
Expire-Date: ${expire_date}
Passphrase: ${gpg_passphrase}
EOF
    "${_gpg}" --quiet --no-verbose --batch --expert --full-gen-key "${key_config}"
    rm -rf "${key_config}"

    # assumed the highest rsa length:
    local signingKey=""
    signingKey=$(
      "${_gpg}" \
        --quiet --no-verbose --list-secret-keys --keyid-format LONG |
        grep -B 2 "${git_email}" |
        grep sec |
        awk -F"[/ ]+" '{print $3}'
    )
    log_done "GPG key ${signingKey} generated" "${icon}"

    touch "${HOME}/.gitconfig.local"
    (
      git config --file="${HOME}/.gitconfig.local" user.name "${git_username}"
      git config --file="${HOME}/.gitconfig.local" user.email "${git_email}"
      git config --file="${HOME}/.gitconfig.local" user.signingKey "${signingKey}"
      git config --file="${HOME}/.gitconfig.local" gpg.program "${_gpg}"
      git config --file="${HOME}/.gitconfig.local" commit.gpgsign true
      git config --file="${HOME}/.gitconfig.local" github.user "${git_username}"
    )

    log_done "Git profile configured" "${icon}"
    log_notice "Remember to upload the GPG and SSH keys to Github" "${icon}"
  else
    log_done "Git already configured" "${icon}"
  fi
}

gen_ssh_key() {
  local name="${1}"
  local password="${2}"
  local comment="${3}"
  local type="${4:-ed25519}"
  ssh-keygen \
    -t "${type}" \
    -b 4096 \
    -C "${comment}" \
    -f "${HOME}/.ssh/${name}" \
    -N "${password}" \
    -q
}

if ((SHLVL > 1)); then
  if ((EUID == 0)) && [[ -z ${CI:-} ]]; then
    log_die "Cannot configure git as root" "${icon}"
  fi
  echo "kornicameister/dotfiles :: git"
  configure_git "$@"
fi
