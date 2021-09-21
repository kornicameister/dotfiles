#!/bin/sh

install_packages() {
    local icon
    icon="[ Y ]"

    log_notice "Installing prerequisites" "${icon}"
    sudo pacman -Syq --needed --noconfirm base-devel git
    _install_yay

    log_notice "Preliminary upgrade" "${icon}"
    yay -Syy

    log_notice "Installing base packages" "${icon}"
    yay -Syq --needed --noconfirm --quiet --combinedupgrade --batchinstall \
        curl \
        lsb-release \
        ruby \
        wget \
        zsh

    log_notice "Installing *env dependencies" "${icon}"
    yay -Syq --needed --noconfirm --quiet --combinedupgrade --batchinstall \
        ccache \
        make \
        openssl \
        zlib

    log_notice "Installing development" "${icon}"
    yay -Syq --needed --noconfirm --quiet --combinedupgrade --batchinstall \
        ctags \
        neovim \
        git \
        git-lfs \
        git-extras \
        meld \
        maven \
        prettier \
        shellcheck \
        shfmt \
        the_silver_searcher \
        subversion \
        yamllint \
        stylua-bin \
        jq \
        yq \
        xfce4-terminal

    log_notice "Installing utilities" "${icon}"
    yay -Syq --needed --noconfirm --combinedupgrade --batchinstall \
        aria2 \
        cron \
        gnupg \
        htop \
        vtop \
        python-wal-vtop \
        httpie \
        lnav \
        nvtop \
        preload \
        ranger \
        screenfetch \
        tlp-rdw \
        tree \
        zathura \
        zathura-pdf-mupdf \
        xclip \
        ueberzug && {
        for srv in tlp cron; do
            sudo systemctl enable --now "${srv}"
            sudo systemctl start "${srv}"
        done
    }

    log_notice "Installing browsers" "${icon}"
    yay -Syq --needed --noconfirm --combinedupgrade --batchinstall \
        brave-bin \
        firefox \
        google-chrome-dev

    log_notice "Installing IDEs" "${icon}"
    yay -Syq --needed --noconfirm --combinedupgrade --batchinstall \
        intellij-idea-community-edition \
        pycharm-community-edition

    log_notice "Installing virtualization" "${icon}"
    yay -Syq --needed --noconfirm --combinedupgrade --batchinstall \
        docker \
        docker-compose \
        ctop \
        fuse-overlayfs \
        hadolint-bin \
        virtualbox && {

        docker_conf=$(mktemp)
        cat >>"${docker_conf}" <<EOF
kernel.unprivileged_userns_clone = 1
EOF
        sudo mv -f "${docker_conf}" /etc/sysctl.d/docker.conf &&
            sudo sysctl --system | grep -o kernel.unprivileged_userns_clone &&
            sudo usermod -aG docker "${WHOAMI}" &&
            sudo systemctl enable --now docker &&
            sudo systemctl start docker
    }

    log_notice "Installing GUI" "${icon}"
    yay -Syq --needed --noconfirm --combinedupgrade --batchinstall \
        i3-gaps \
        i3status \
        i3lock \
        feh \
        rofi \
        dunst \
        python-pywal \
        polybar \
        polybar-spotify-module \
        picom && {
        systemctl --user enable spotify-listener
        systemctl --user start spotify-listener
    }

    log_notice "Installing themes & fonts" "${icon}"
    yay -Syq --needed --noconfirm --combinedupgrade --batchinstall \
        ttf-iosevka \
        ttf-font-awesome \
        ttf-material-design-icons \
        ant-dracula-gtk-theme

    log_notice "Installing " "${icon}"
    yay -Syq --needed --noconfirm --combinedupgrade --batchinstall \
        bluez \
        bluez-utils \
        blueman && {
        sudo systemctl enable bluetooth.service
        sudo systemctl start bluetooth.service
    }

    log_notice "Installing multimedia" "${icon}"
    yay -Syq --needed --noconfirm --combinedupgrade --batchinstall \
        spotify \
        avizo \
        pulseaudio-alsa \
        pulseaudio-bluetooth

    lspci -k | grep -qe "NVIDIA" && {
        log_notice "Installing NVIDIA" "${icon}"
        yay -Sq --needed --noconfirm nvidia
    }

    log_notice "Installing " "${icon}"
    yay -Syq --needed --noconfirm --combinedupgrade --batchinstall \
        slack \
        zoom

    log_notice "Removing things I do not need" "${icon}"
    _remove_redundant_packages
}

_yay_clean() {
    yay -Sqy
    yay -Rsn --noconfirm "$(yay -Qdtq)" 2>/dev/null || true # remove unneeded dependencies
    yay --afterclean --removemake --save
}

_remove_redundant_packages() {
    yay -Rs --noconfirm \
        nano \
        termite \
        alacritty \
        xterm \
        terminator \
        nitrogen \
        xterm || true
    _yay_clean
}

_install_yay() {
    command -v yay >/dev/null || {
        rm -rf /tmp/yay || true
        git clone https://aur.archlinux.org/yay.git --depth 1 /tmp/yay
        pushd /tmp/yay || exit
        makepkg -si
        popd || exit
    } && log_notice "Yay is already installed" "[  ]"
}

if ((SHLVL > 1)); then
  install_packages
fi
