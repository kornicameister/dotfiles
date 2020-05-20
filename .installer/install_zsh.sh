#!/usr/bin/env sh

# install previously installed zsh
aptitude remove zsh -y -V -D -Z

dir="$(mktemp -t -d kdotfiles-zsh.XXXXXXXXXX)"
zsh_remote_version=$(git ls-remote https://github.com/zsh-users/zsh | grep refs/tags | grep -oP "zsh-[0-9]\\.[0-9](\\.[0-9])?" | tail -n 1)

aria2c \
  "https://github.com/zsh-users/zsh/archive/${zsh_remote_version}.tar.gz" \
  -d "${dir}" \
  -o "zsh.tar.gz"

cd "${dir}" && {
  tar zxf zsh.tar.gz
  cd "$(find . -type d -name '*zsh*')" || exit 1

  ./Util/preconfig
  ./configure \
    --enable-multibyte \
    --enable-zsh-mem \
    --enable-pcre \
    --enable-cap

  make clean
  make -j
  make install.bin
  make install.modules
  make install.fns
  make install.info

  cd ... || exit 1

  test -f /bin/zsh || ln -s "$(command -v zsh)" /bin/zsh
  grep /bin/zsh /etc/shells >/dev/null || {
    echo /bin/zsh | tee -a /etc/shells
  }
}
rm -rf "${dir}"
