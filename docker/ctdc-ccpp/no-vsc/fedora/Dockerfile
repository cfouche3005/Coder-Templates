FROM cf3005/ctdc-base:fedora-no-vsc

USER root

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