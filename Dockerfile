FROM buildpack-deps:22.04-curl 
LABEL maintainer="Swire Chen <idoop@msn.cn>"

#ADD https://raw.githubusercontent.com/easysoft/zentaopms/master/www/upgrade.php.tmp /tmp/upgrade.php
COPY upgrade.php /tmp/upgrade.php

COPY docker-entrypoint /usr/local/bin/docker-entrypoint

RUN apt-get update \
    && apt-get install -y --no-install-recommends iproute2 sudo \
    && rm -rf /var/lib/apt/lists/*

ENV ZENTAO_VER=21.7
ARG ZENTAO_URL=https://www.zentao.net/dl/zentao/${ZENTAO_VER}/ZenTaoPMS-${ZENTAO_VER}-zbox_amd64.tar.gz

RUN curl --dns-servers 1.2.4.8 -sSL ${ZENTAO_URL} -o /tmp/zbox.tar.gz \
    && chmod +x /usr/local/bin/docker-entrypoint

HEALTHCHECK --start-period=20s --interval=45s --timeout=3s CMD wget http://localhost/ -O /dev/null || exit 1

EXPOSE 80 3306

ENTRYPOINT ["docker-entrypoint"]
