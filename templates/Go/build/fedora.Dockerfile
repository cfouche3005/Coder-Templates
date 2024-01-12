FROM cf3005/ctdc-base:fedora

ARG FLEET
ARG VSCODE

USER root

RUN /tools/ide-install.sh >> /root/ide-install.log 2>&1

ENV VERSION=1.21.6

RUN if [ "$(uname -m)" == "aarch64" ]; then \
        wget -q https://golang.org/dl/go${VERSION}.linux-arm64.tar.gz -O /tmp/go.tar.gz; \
    else \
        wget -q https://golang.org/dl/go${VERSION}.linux-amd64.tar.gz -O /tmp/go.tar.gz; \
    fi && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz

USER coder

RUN echo "export PATH=\$PATH:/usr/local/go/bin" >> /home/coder/.zshrc