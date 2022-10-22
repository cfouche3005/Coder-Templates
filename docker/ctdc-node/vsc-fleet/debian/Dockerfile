FROM cf3005/ctdc-base:debian-vsc-fleet

USER root

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash -

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER coder

RUN curl -fsSL https://bun.sh/install | bash

RUN echo 'export BUN_INSTALL="$HOME/.bun"' >> /home/coder/.zshrc && echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> /home/coder/.zshrc

#a