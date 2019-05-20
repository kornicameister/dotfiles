#!/bin/sh

set -x

if [ ! -f "$(pyenv root)/version" ]; then
    echo "Installing latest python"

    pyenv latest install -s 2
    pyenv latest install -s 3
    pyenv latest --print 3 >> "$(pyenv root)/version"
fi
if [ ! -f "$(nodenv root)/version" ]; then
    echo "Installing latest node"

    nodenv latest install -s 12
    nodenv latest --print 12 >> "$(nodenv root)/version"
fi

set +x
