FROM cf3005/ctdc-base:debian-vsc-fleet

USER root

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    apache2 \
    php \
    libapache2-mod-php \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/www/html/info
RUN echo "<?php" >> /var/www/html/info/info.php && \
    echo "  phpinfo();" >> /var/www/html/info/info.php && \
    echo "?>" >> /var/www/html/info/info.php
RUN chown -R coder /var/www/html

USER coder

#b