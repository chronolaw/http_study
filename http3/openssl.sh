#!/bin/bash

# copyright chrono @2020

git clone --depth 1 -b OpenSSL_1_1_1d-quic-draft-27 https://github.com/tatsuhiro-t/openssl
cd openssl
./config enable-tls1_3 --prefix=/opt/openssl_quic
make
#make install_sw
