-- Copyright (C) 2019 by chrono

local cookie = ngx.var.http_cookie

--ngx.header['Content-Type'] = 'text/plain'

if cookie and string.find(cookie, 'favorite') then
    ngx.say("your cookie is [", cookie, "]\n")
    return
end

local max_age = 10

local fields = {
    --'uid=2019-9999',
    'favorite=hamburger',
    'Max-Age=' .. max_age,
    'Expires=' ..  ngx.cookie_time(ngx.time() + max_age),   -- 3600*12*90
    'Domain=' ..  ngx.var.host,
    'Path=/',
    'HttpOnly',
    'SameSite=Strict',
    }

ngx.header['Set-Cookie'] = table.concat(fields, '; ')

--[[
ngx.header['Set-Cookie'] = 'uid=2019-9999; ' ..
                           'expires=' ..
                             ngx.cookie_time(ngx.time() + 10) ..
                             ';' ..
                           'domain=' ..
                             ngx.var.host .. '; ' ..
                           'path=/; ' ..
                           'HttpOnly'
--]]

ngx.say("your have no cookie, please visit again. ")

