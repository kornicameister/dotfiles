#/bin/sh

PWD=${PWD}

echo "kornicameister/dotfiles installer"

sudo true
sudo apt-get update -q
sudo apt-get install git -y -q

echo "I think I have everything I need, dotfiles will be installed in the directory from which script was called"

git clone https://github.com/kornicameister/dotfiles.git
pushd ./dotfiles

git submodule update --init --recursive
./install "$@"

popd
