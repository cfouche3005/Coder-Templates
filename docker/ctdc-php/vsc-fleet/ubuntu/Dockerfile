FROM cf3005/ctdc-base:ubuntu-vsc-fleet

USER root

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    apache2 \
    php \
    libapache2-mod-php \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/ww/html/info
RUN echo "<?php" >> /var/ww/html/info/info.php && \
    echo "  phpinfo();" >> /var/ww/html/info/info.php && \
    echo "?>" >> /var/ww/html/info/info.php
RUN chown -R coder /var/ww/html

USER coder

#a