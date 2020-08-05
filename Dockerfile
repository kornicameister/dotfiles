ARG OS_NAME=ubuntu
ARG OS_VERSION=20.04

FROM ${OS_NAME}:${OS_VERSION} AS prerequisites

RUN apt-get -qq update && \
    apt-get -yqq --no-install-recommends install apt-utils  && \
    apt-get -yqq --no-install-recommends install \
      git \
      locales \
      ssh \
      ca-certificates \
      lsb-release && \
    apt-get -yqq autoclean && \
    apt-get -yqq autoremove && \
    rm -rf /var/apt/cache/**

FROM prerequisites AS tz_configuration

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/Europe select Warsaw' | debconf-set-selections && \
    echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8' | debconf-set-selections && \
    echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections && \
    echo 'keyboard-configuration  keyboard-configuration/layout select  English (UK)' | debconf-set-selections && \
    locale-gen en_US.UTF-8 && \
    ln -fs /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && \
    apt-get -qq update && \
    apt-get -yqq --no-install-recommends install tzdata && \
    apt-get -yqq autoclean && \
    apt-get -yqq autoremove && \
    rm -rf /var/apt/cache/**

FROM tz_configuration AS user_add

ARG K_USERNAME
RUN groupadd ${K_USERNAME} && useradd -ms /bin/bash ${K_USERNAME}

FROM user_add AS clone

WORKDIR /
ADD dotfiles ./
WORKDIR /dotfiles

ARG K_USERNAME
ARG K_PASSWORD
ARG K_EMAIL
ARG K_GPG_FULLNAME
ARG K_GPG_PASSPHRASE
ARG K_WAKATIME_API_KEY

RUN ./install \
    "${K_USERNAME}" \
    "${K_PASSWORD}" \
    "${K_EMAIL}" \
    "${K_GPG_FULLNAME}" \
    "${K_GPG_PASSPHRASE}" \
    "${K_WAKATIME_API_KEY}"
