FROM fedora:latest

SHELL ["/bin/bash", "-c"]

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
    bash \
    curl \
    htop \
    man \
    sudo \
    systemd \
    systemd-sysv \
    dbus \
    unzip \
    nano \
    zsh \
    wget \
    git \
    && dnf clean all

RUN systemctl mask systemd-udevd.service \
                   systemd-udevd-kernel.socket \
                   systemd-udevd-control.socket \
                   systemd-modules-load.service \
                   sys-kernel-config.mount \
                   sys-kernel-debug.mount \
                   sys-kernel-tracing.mount\
                   systemd-journald-audit.socket \
                   systemd-udev-trigger.service \
                   systemd-firstboot.service \
                   systemd-networkd-wait-online.service

RUN cd /usr/bin && if [ "$(uname -m)" == "aarch64" ]; then curl -LSs "https://download.jetbrains.com/product?code=FLL&release.type=eap&platform=linux_aarch64" --output fleet && chmod +x fleet; else curl -LSs "https://download.jetbrains.com/product?code=FLL&release.type=eap&platform=linux_x64" --output fleet && chmod +x fleet; fi;

RUN useradd coder \
      --create-home \
      --shell=/bin/zsh \
      --uid=1000 \
      --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER coder

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

RUN sed -i.bak "s+robbyrussell+powerlevel10k/powerlevel10k+g" /home/coder/.zshrc

#a