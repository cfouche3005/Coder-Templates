FROM cf3005/ctdc-base:fedora

ARG FLEET
ARG VSCODE

USER root

RUN /tools/ide-install.sh >> /root/ide-install.log 2>&1

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
    httpd \
    php-xdebug \
    php \
    php-pgsql \
    && dnf clean all

RUN mkdir /var/www/html/info
RUN echo "<?php" >> /var/www/html/info/info.php && \
    echo "  phpinfo();" >> /var/www/html/info/info.php && \
    echo "?>" >> /var/www/html/info/info.php
RUN chown -R coder /var/www/html

USER coder