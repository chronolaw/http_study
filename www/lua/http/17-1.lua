-- Copyright (C) 2019 by chrono

local target = ngx.var.arg_dst or '/index.html'

local code = tonumber(ngx.var.arg_code or 302)

if code ~= 301 and code ~= 302 then
    code = 302
end

local new_uri = target

--if string.byte(new_uri) ~= string.byte('/') then
--    new_uri = '/' .. new_uri
--end

ngx.header['Referer'] = ngx.var.request_uri

ngx.redirect(new_uri, code)

