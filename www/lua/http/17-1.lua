-- Copyright (C) 2019 by chrono

local target = ngx.var.arg_dst
local code = tonumber(ngx.var.arg_code or 302)

if code ~= 301 and code ~= 302 then
    code = 302
end

local new_uri = target or 'index.html'

ngx.header['Referer'] = ngx.var.request_uri

ngx.redirect('/' .. new_uri, code)

