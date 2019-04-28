-- Copyright (C) 2019 by chrono
-- test ssl handshake

local ssl = require "ngx.ssl"

local scheme = ngx.var.scheme
if scheme ~= 'https' then
    --ngx.log(ngx.ERR, scheme)
    return ngx.redirect(
        'https://'..ngx.var.host..ngx.var.request_uri, 301)
end

local str = 'ssl handshake by '..
            ssl.get_tls1_version_str() ..'\n'
--local str = string.format('ssl = %x\n', ssl.get_tls1_version())

ngx.header['Content-Length'] = #str

ngx.print(str)
