-- Copyright (C) 2019 by chrono

--#!/usr/local/openresty/bin/resty

local os = jit.os

ngx.say('http study on ', os, '\n')

ngx.say('nginx core is ', ngx.config.nginx_version, '\n')

ngx.say('configure is \n')

ngx.say(ngx.config.nginx_configure())

