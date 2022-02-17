ARG FRM='testdasi/openvpn-client-rio-base'
ARG TAG='latest'
ARG DEBIAN_FRONTEND='noninteractive'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG
ARG BUILD_OPT

ENV LANG en_GB.UTF-8
ENV LAUNCHER_GUI_PORT 8000
ENV DNS_SERVER_PORT 53
ENV SOCKS_PROXY_PORT 9118
ENV HTTP_PROXY_PORT 8118
ENV TOR_SOCKS_PORT 9119
ENV TOR_HTTP_PORT 8119
ENV USENET_HTTP_PORT 8080
ENV USENET_HTTPS_PORT 8090
ENV TORRENT_GUI_PORT 3000
ENV SEARCHER_GUI_PORT 5076
ENV PVR_TV_PORT 8989
ENV PVR_MOVIE_PORT 7878
ENV TORZNAB_PORT 9117
ENV INDEXER_PORT 9696
ENV DNS_SERVERS 127.2.2.2
ENV HOST_NETWORK 192.168.1.0/24
ENV SERVER_IP 192.168.1.2

EXPOSE ${LAUNCHER_GUI_PORT}/tcp \
    ${DNS_SERVER_PORT}/tcp \
    ${DNS_SERVER_PORT}/udp \
    ${SOCKS_PROXY_PORT}/tcp \
    ${HTTP_PROXY_PORT}/tcp \
    ${TOR_SOCKS_PORT}/tcp \
    ${TOR_HTTP_PORT}/tcp \
    ${USENET_HTTP_PORT}/tcp \
    ${USENET_HTTPS_PORT}/tcp \
    ${TORRENT_GUI_PORT}/tcp \
    ${SEARCHER_GUI_PORT}/tcp \
    ${PVR_TV_PORT}/tcp \
    ${PVR_MOVIE_PORT}/tcp \
    ${TORZNAB_PORT}/tcp \
    ${INDEXER_PORT}/tcp

## build note ##
RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM}:${TAG}" >> /build.info

## install static codes ##
RUN rm -Rf /testdasi \
    && mkdir -p /temp \
    && cd /temp \
    && curl -sL "https://github.com/testdasi/static-ubuntu/archive/main.zip" -o /temp/temp.zip \
    && unzip /temp/temp.zip \
    && rm -f /temp/temp.zip \
    && mv /temp/static-ubuntu-main /testdasi \
    && rm -Rf /testdasi/deprecated

RUN cp /testdasi/scripts-debug/* / && chmod +x /*.sh

## execute execute execute ##
RUN /bin/bash /testdasi/scripts-install/install-openvpn-client-rio.sh

## debug mode (comment to disable) ##
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]

## Final clean up ##
RUN rm -Rf /testdasi

## VEH ##
#VOLUME ["/config"]
#ENTRYPOINT ["tini", "--", "/static-ubuntu/scripts-openvpn/entrypoint.sh"]
#HEALTHCHECK CMD /static-ubuntu/scripts-openvpn/healthcheck.sh
