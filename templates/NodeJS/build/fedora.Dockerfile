FROM cf3005/ctdc-base:fedora

ARG FLEET
ARG VSCODE

USER root

RUN /tools/ide-install.sh >> /root/ide-install.log 2>&1

RUN curl -fsSL https://raw.githubusercontent.com/nodesource/distributions/master/rpm/setup_lts.x | bash -

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
    nodejs \
    && dnf clean all

USER coder

RUN curl -fsSL https://bun.sh/install | bash

RUN echo 'export BUN_INSTALL="$HOME/.bun"' >> /home/coder/.zshrc && echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> /home/coder/.zshrc