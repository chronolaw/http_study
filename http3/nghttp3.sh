#!/bin/bash

# copyright chrono @2020

git clone https://github.com/ngtcp2/nghttp3
cd nghttp3
autoreconf -i
./configure --prefix=/opt/nghttp3 --enable-lib-only
make
#make install

