FROM cf3005/ctdc-base:ubuntu

ARG FLEET
ARG VSCODE

USER root

RUN /tools/ide-install.sh >> /root/ide-install.log 2>&1

USER coder