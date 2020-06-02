#!/bin/bash

# copyright chrono @2020

git clone https://github.com/curl/curl
cd curl

./buildconf
LDFLAGS="-Wl,-rpath,/opt/openssl_quic/lib" \
    ./configure \
    --with-ssl=/opt/openssl_quic \
    --with-nghttp3=/opt/nghttp3 \
    --with-ngtcp2=/opt/ngtcp2 \
    --enable-alt-svc

make

