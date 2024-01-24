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
    ca-certificates \
    dbus \
    iptables \
    kmod \
    unzip \
    nano \
    zsh \
    wget \
    git \
    openssh \
    dnf-plugins-core \
    python3-pip \
    && dnf clean all

RUN pip install pyftpdlib

RUN dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
    tailscale \
    && dnf clean all

RUN systemctl enable tailscaled

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

RUN useradd coder \
      --create-home \
      --shell=/bin/zsh \
      --uid=1000 \
      --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER coder

RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions;
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting;
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k;
RUN echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc;
RUN echo 'source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc;
RUN echo 'source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >>~/.zshrc;