# Dockerfile
# chrono @ 2020-08

ARG RESTY_IMAGE="openresty/openresty:bionic"

FROM ${RESTY_IMAGE}

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        sudo vim git tcpdump \
    && cd \
    && git clone https://github.com/chronolaw/http_study

EXPOSE 80
EXPOSE 8080
EXPOSE 443
EXPOSE 8443
