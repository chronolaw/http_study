##!/usr/bin/env bash

openresty_path="/usr/local/openresty"
openresty="${openresty_path}/bin/openresty"

# openresty needs ./logs
if [ ! -d "logs" ]; then
    mkdir logs
fi

if [ $# -ne 1 ] ; then
    $openresty -v
    echo "format : $0 [start|stop|reload|list]"
    exit 0
fi

opts="-p `pwd`"

if [[ $1 != "start" && $1 != "stop" && $1 != "reload" && $1 != "list" ]] ; then
    echo "format : $0 [start|stop|reload]|list"
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

