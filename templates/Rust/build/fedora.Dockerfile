FROM cf3005/ctdc-base:fedora

ARG FLEET
ARG VSCODE

USER root

RUN /tools/ide-install.sh >> /root/ide-install.log 2>&1

USER coder

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y