FROM cf3005/ctdc-base:fedora-vsc

USER root

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
    python3.9 \
    && dnf clean all

USER coder

#a