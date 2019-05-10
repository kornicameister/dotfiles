#!/bin/bash

curl -s https://brave-browser-aptitude-beta.s3.brave.com/brave-core-nightly.asc |  aptitude-key --keyring /etc/aptitude/trusted.gpg.d/brave-browser-beta.gpg add -
echo "deb [arch=amd64] https://brave-browser-aptitude-beta.s3.brave.com/ trusty main" |  tee /etc/aptitude/sources.list.d/brave-browser-beta-trusty.list

aptitude update -q -y
aptitude install -y -V -D -Z brave-browser-beta
