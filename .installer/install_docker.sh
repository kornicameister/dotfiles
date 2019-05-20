#!/bin/bash

set -x

# docker
aptitude remove \
    docker-ce \
    docker \
    docker-engine \
    docker.io -y -V -D -Z

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
wget -qO- https://get.docker.com/ | sh

# docker-compose
compose_version=$(git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\\.[0-9][0-9]+\\.[0-9]+$" | tail -n 1)
sh -c "curl -L https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose"
chmod +x /usr/local/bin/docker-compose

set +x
