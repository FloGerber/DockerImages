FROM debian:stable-slim

ENV LANG=C.UTF-8

RUN export DEBIAN_FRONTEND=noninteractive \
    && echo "APT::Install-Recommends "0" ; APT::Install-Suggests "0" ;" > /etc/apt/apt.conf.d/default \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y apt-utils \
    && apt-get update \
    && apt-get install -y ca-certificates curl gnupg wget jq \
    && cd /tmp \
    && latest_azqr=$(curl -sL https://api.github.com/repos/Azure/azqr/releases/latest | jq -r ".tag_name" | cut -c1-)  \
    && wget https://github.com/Azure/azqr/releases/download/$latest_azqr/azqr-ubuntu-latest-amd64 -O azqr \
    && chmod +x azqr \
    && mv azqr /usr/bin \
    && azqr completion bash \
    && rm -rf /tmp/* \
    && apt-get remove -y wget curl apt-utils jq \
    && apt-get autoremove --purge -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* 
