FROM cf3005/ctdc-base:ubuntu-fleet

USER root

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    gcc \
    clang \
    gdb \
    valgrind \
    g++ \
    libc6-dev \
    make \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER coder

#a