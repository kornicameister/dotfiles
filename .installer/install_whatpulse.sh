#!/bin/bash

if [[ -z "${WHATPULSE_USER}" ]]; then
  echo "WHATPULSE_USER is required"
  exit 1
fi

echo "user ===> ${WHATPULSE_USER}"

version="313"

if _=$((1 << 32)); then
  arch=64
else
  arch=32
fi

aptitude install -y -q \
  libqt5widgets5 \
  libqt5sql5-sqlite \
  libqt5script5 \
  libqt5xml5 \
  libssl-dev

download_url="https://whatpulse.org/downloads/${version}/${arch}bit/" && echo "Downloading from ${download_url}"
download_dir="$(mktemp -t -d kdotfiles-whatpulse.XXXXXXXXXX)"
aria2c "${download_url}" -d "${download_dir}" -o whatpulse.tar.gz

cd "${download_dir}" && (
  tar -xvf whatpulse.tar.gz -C "${PWD}"
  setcap cap_net_raw,cap_net_admin=eip "${PWD}/whatpulse"
  yes "${WHATPULSE_USER}" | sudo ./setup-input-permissions.sh
  cp -f "${PWD}/whatpulse" "/usr/local/bin/whatpulse"
)
rm -rf "${download_dir}" && whatpulse --version
