FROM cf3005/ctdc-base:debian-vsc

USER root

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    python3.10 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER coder

#a