#!/bin/bash

# copyright chrono @2020

git clone https://github.com/ngtcp2/ngtcp2
cd ngtcp2
autoreconf -i
./configure \
    PKG_CONFIG_PATH=/opt/nghttp3/lib/pkgconfig:/opt/nghttp3/lib/pkgconfig \
    LDFLAGS="-Wl,-rpath,/opt/openssl_quic/lib" \
    --prefix=/opt/ngtcp2
make
#make install
