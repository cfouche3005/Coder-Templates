FROM cf3005/ctdc-base:fedora-vanilla

USER root

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
   python3.10 \
    && dnf clean all

USER coder

#b