#!/bin/bash

# docker
aptitude remove \
    docker-ce \
    docker \
    docker-engine \
    docker.io \
    runc \
    containerd \
    -y -V -D -Z


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   edge"

aptitude update -q -y
aptitude install docker-ce docker-ce-cli containerd.io -y -V -D -Z

# docker-compose
compose_version=$(git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\\.[0-9][0-9]+\\.[0-9]+$" | tail -n 1)
sh -c "curl -L https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose"
chmod +x /usr/local/bin/docker-compose
