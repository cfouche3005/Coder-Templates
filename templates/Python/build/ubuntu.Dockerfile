FROM cf3005/ctdc-base:ubuntu

ARG FLEET
ARG VSCODE

USER root

RUN /tools/ide-install.sh >> /root/ide-install.log 2>&1

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    python3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER coder