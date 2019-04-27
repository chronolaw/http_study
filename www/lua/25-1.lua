-- Copyright (C) 2019 by chrono
-- test ssl handshake

local scheme = ngx.var.scheme
if scheme ~= 'https' then
    --ngx.log(ngx.ERR, scheme)
    return ngx.redirect(
        'https://'..ngx.var.host..ngx.var.request_uri, 301)
end

local str = 'ssl handshake with ' .. ngx.var.ssl_cipher .. '\n'

ngx.header['Content-Length'] = #str

ngx.print(str)
