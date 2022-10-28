FROM cf3005/ctdc-base:fedora-vanilla

USER root

RUN curl -fsSL https://rpm.nodesource.com/setup_current.x | bash -

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
    nodejs \
    && dnf clean all

USER coder

RUN curl -fsSL https://bun.sh/install | bash

RUN echo 'export BUN_INSTALL="$HOME/.bun"' >> /home/coder/.zshrc && echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> /home/coder/.zshrc

#b