FROM mcr.microsoft.com/powershell:lts-azurelinux-3.0-arm64

ENV LANG=C.UTF-8
ENV SHELL=/bin/bash
#ARG SKIP_PUBLISHER_CHECK=TRUE
ARG REPOSITORY=PSGallery

COPY ./snippets ./

RUN pwsh -Command Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
    && pwsh -Command Install-Module -Name Az -Force -Scope AllUsers -Repository PSGallery \
    && pwsh -Command Install-Module -Name Microsoft.Graph -Force -Scope AllUsers \
    && pwsh -Command Install-Module -Name PSWritePDF -Force -Scope AllUsers \
    && pwsh -Command New-Item -Path $profile -type file -force

CMD [ "pwsh" ]