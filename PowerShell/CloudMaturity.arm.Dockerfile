FROM arm64v8/debian:stable-slim

ENV LANG=C.UTF-8
#ARG SKIP_PUBLISHER_CHECK=TRUE

COPY ./snippets ./

SHELL [ "/bin/bash", "-c" ]

RUN export DEBIAN_FRONTEND=noninteractive \
    && echo "APT::Install-Recommends "0" ; APT::Install-Suggests "0" ;" > /etc/apt/apt.conf.d/default \
    && apt-get update  \
    && apt-get upgrade -y \
    && apt-get install -y wget ca-certificates curl jq \
    && apt-get install -y libc6 libgcc-s1 libgssapi-krb5-2 libicu72 libssl3 libstdc++6 zlib1g libunwind8 \
    && update-ca-certificates --fresh \
    && bits=$(getconf LONG_BIT) \
    ## Comment the following line and Uncomment the ones after for latest ps version, not working as of 9.Juli so pinning to latest lts
    && package=https://github.com/PowerShell/PowerShell/releases/download/v7.4.11/powershell-7.4.11-linux-arm${bits}.tar.gz \
    # && release=$(curl -sL https://api.github.com/repos/PowerShell/PowerShell/releases/latest) \              
    # && package=$(echo $release | jq -r ".assets[].browser_download_url" | grep "linux-arm${bits}.tar.gz") \
    && curl -L -o /tmp/powershell.tar.gz $package \
    && mkdir -p /opt/microsoft/powershell/7 \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 \
    && chmod +x /opt/microsoft/powershell/7/pwsh \
    && ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh \
    && rm -rf /tmp/* \
    && apt-get remove -y wget ca-certificates curl jq \
    && apt-get autoremove --purge -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
SHELL [ "pwsh", "-command" ]

RUN Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; \
    Install-Module -Name Az -Force -Scope AllUsers; \
    Install-Module -Name Microsoft.Graph -Force -Scope AllUsers; \
    Install-Module -Name PSWritePDF -Force -Scope AllUsers; \
    Install-Module -Name PSWriteHTML -Force -Scope AllUsers; \
    Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted ; \
    New-Item -Path $profile -type file -force

CMD [ "pwsh" ]