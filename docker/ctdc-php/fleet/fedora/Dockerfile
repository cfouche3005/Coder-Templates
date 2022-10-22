FROM cf3005/ctdc-base:fedora-fleet

USER root

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
    apache2 \
    php \
    libapache2-mod-php \
    && dnf clean all

RUN mkdir /var/ww/html/info
RUN echo "<?php" >> /var/ww/html/info/info.php && \
    echo "  phpinfo();" >> /var/ww/html/info/info.php && \
    echo "?>" >> /var/ww/html/info/info.php
RUN chown -R coder /var/ww/html

USER coder

#a