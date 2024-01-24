FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]

RUN if id -u ubuntu > /dev/null 2>&1; then userdel -r ubuntu; fi

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
      bash \
      curl \
      htop \
      man \
      software-properties-common \
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
      ssh \
      python3-pyftpdlib \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
      tailscale \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

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