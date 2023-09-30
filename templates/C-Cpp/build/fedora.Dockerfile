FROM cf3005/ctdc-base:fedora

ARG FLEET
ARG VSCODE

USER root

RUN /tools/ide-install.sh >> /root/ide-install.log 2>&1

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
    gcc \
    clang \
    gdb \
    valgrind \
    g++ \
    glibc-devel \
    make \
    && dnf clean all

USER coder