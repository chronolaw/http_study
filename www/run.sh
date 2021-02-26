#!/usr/bin/env bash

# Linux
openresty_path="/usr/local/openresty"
openresty="${openresty_path}/bin/openresty"

os=`uname`

# os = Darwin = macOS
if [ $os != "Linux" ] ; then
    openresty="/usr/local/bin/openresty"
fi

# openresty needs ./logs
if [ ! -d "logs" ]; then
    mkdir logs
fi

if [ $# -ne 1 ] ; then
    $openresty -v
    echo "format : $0 [start|stop|reload|list]"
    exit 0
fi

opts="-c conf/nginx.conf -p `pwd`"

if [[ $1 != "start" && $1 != "stop" && $1 != "reload" && $1 != "list" ]] ; then
    echo "format : $0 [start|stop|reload|list]"
    exit 1
fi

if [ $1 == "start" ] ; then
    sudo $openresty $opts
    exit 0
fi

if [ $1 == "list" ] ; then
    ps -ef|grep nginx|grep -v 'grep'
    exit 0
fi

opts="$opts -s $1"

sudo $openresty $opts

