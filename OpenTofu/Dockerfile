FROM debian:stable-slim

#ARG GITLAB_TF_ACCESS_TOKEN

ENV LANG=C.UTF-8

COPY ./system/usr/local /usr/local
COPY ./system/root/ /root/

RUN export DEBIAN_FRONTEND=noninteractive \
    && sed -i "s/ACCESSTOKEN/${GITLAB_TF_ACCESS_TOKEN}/g" root/.terraform.d/credentials.tfrc.json \
    && echo "APT::Install-Recommends "0" ; APT::Install-Suggests "0" ;" > /etc/apt/apt.conf.d/default \
    && apt update  \
    && apt upgrade -y \
    && apt install -y apt-utils ca-certificates unzip ssh curl file apt-transport-https gnupg wget file jq lsb-release software-properties-common \
    && ssh-keygen -q -t ed25519 -N '' -C \"Terraform_SSH_Key\" -f ~/.ssh/ssh_key \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://get.opentofu.org/opentofu.gpg | tee /etc/apt/keyrings/opentofu.gpg >/dev/null \
    && curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null \
    && chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg \
    && echo \
        "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main \
        deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | \
        tee /etc/apt/sources.list.d/opentofu.list > /dev/null \
    && chmod a+r /etc/apt/sources.list.d/opentofu.list \
    && wget https://apt.boltops.com/packages/terraspace/terraspace-latest.deb \
    && dpkg -i terraspace-latest.deb \
    #&& curl -s https://apt.boltops.com/boltops-key.public | apt-key add - \
    #&& echo "deb https://apt.boltops.com stable main" > /etc/apt/sources.list.d/boltops.list \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt update \
    && apt install -y tofu=1.9.1 terraspace=2.2.15-1 \
    # && cd /tmp \
    # && wget https://github.com/Azure/kubelogin/releases/download/v0.0.11/kubelogin-linux-amd64.zip \
    # && unzip kubelogin-linux-amd64.zip \
    # && mv bin/linux_amd64/kubelogin /usr/bin \
    && terraspace new project init --plugin none --no-examples \
    && rm -rf /tmp/* \
    && apt remove -y lsb-release software-properties-common unzip wget curl apt-transport-https apt-utils \
    && apt autoremove --purge -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates --fresh
