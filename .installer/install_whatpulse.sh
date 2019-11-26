#!/bin/bash

arch="$( if ((1<<32)); then echo 64; else echo 32; fi;)"
version="313"  # for ubuntu derivates

aptitude install -y -qq \
  libqt5widgets5 \
  libqt5sql5-sqlite \
  libqt5script5

download_url="https://whatpulse.org/downloads/${version}/{$arch}bit/"

# setcap cap_net_raw,cap_net_admin=eip ./whatpulse
