-- Copyright (C) 2019 by chrono
-- test ssl handshake

local ssl = require "ngx.ssl"

local scheme = ngx.var.scheme
if scheme ~= 'https' then
    --ngx.log(ngx.ERR, scheme)
    return ngx.redirect(
        'https://'..ngx.var.host..ngx.var.request_uri, 301)
end

local strs = {}

strs[#strs + 1] = 'ssl handshake by ' ..  ssl.get_tls1_version_str()
strs[#strs + 1] = 'ssl session id is [' .. (ngx.var.ssl_session_id or '') .. ']'
strs[#strs + 1] = 'reused? ' .. (ngx.var.ssl_session_reused == 'r' and 'true' or 'false')

local str = table.concat(strs, '\n\n')

ngx.header['Content-Length'] = #str

ngx.print(str)
