FROM debian:stable-slim

ENV LANG=C.UTF-8
#ARG SKIP_PUBLISHER_CHECK=TRUE

COPY ./snippets ./

RUN export DEBIAN_FRONTEND=noninteractive \
    && echo "APT::Install-Recommends "0" ; APT::Install-Suggests "0" ;" > /etc/apt/apt.conf.d/default \
    && apt update  \
    && apt upgrade -y \
    && apt install -y wget ca-certificates \
    && update-ca-certificates --fresh \
    && VERSION_ID=$(grep "^VERSION_ID=" /etc/os-release | cut -d'=' -f2 | tr -d '"') \
    && wget https://packages.microsoft.com/config/debian/$(echo $VERSION_ID)/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt update \
    && apt install -y powershell \
    && rm -rf /tmp/* \
    && apt remove -y wget ca-certificates \
    && apt autoremove --purge -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*
SHELL [ "pwsh", "-command" ]
    RUN Install-Module -Name Microsoft365DSC -Force -Scope AllUsers; \
    Update-M365DSCDependencies; \
    New-Item -Path $profile -type file -force
