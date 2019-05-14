#!/bin/bash

distro=$(lsb_release -si 2>&1)

curl -s https://brave-browser-apt-beta.s3.brave.com/brave-core-nightly.asc |  apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-beta.gpg add -

if [[ "${distro}" == "LinuxMint" ]]; then
  echo "deb [arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ trusty main" |  tee /etc/apt/sources.list.d/brave-browser-beta-trusty.list
elif [[ "${distro}" == "Ubuntu" ]]; then
  source /etc/os-release
  echo "deb [arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ $UBUNTU_CODENAME main" | tee "/etc/apt/sources.list.d/brave-browser-beta-${UBUNTU_CODENAME}.list"
fi

aptitude update -q -y
aptitude install -y -V -D -Z brave-browser-beta
