FROM cf3005/ctdc-base:ubuntu

ARG FLEET
ARG VSCODE

USER root

RUN /tools/ide-install.sh >> /root/ide-install.log 2>&1

RUN curl -fsSL https://raw.githubusercontent.com/nodesource/distributions/master/deb/setup_lts.x | bash -

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER coder

RUN curl -fsSL https://bun.sh/install | bash

RUN echo 'export BUN_INSTALL="$HOME/.bun"' >> /home/coder/.zshrc && echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> /home/coder/.zshrc