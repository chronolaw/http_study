-- Copyright (C) 2019 by chrono

local cookie = ngx.var.http_cookie

ngx.header['Content-Type'] = 'text/plain'

if cookie then
    ngx.say("your cookie is [", cookie, "]\n")
    return
end

ngx.header['Set-Cookie'] = 'uid=2019-9999; ' ..
                           'path=/; ' ..
                           'expires=' ..
                             ngx.cookie_time(ngx.time() + 10) ..
                             ';' ..
                           'domain=*.chrono.com; ' ..
                           'HttpOnly'

ngx.say("your have no cookie, please visit again. ")


