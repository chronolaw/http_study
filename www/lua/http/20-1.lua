-- Copyright (C) 2019 by chrono

local cookie = ngx.var.http_cookie

if cookie then
    ngx.say("your cookie is ", cookie)
    return
end

ngx.header['Content-Type'] = 'text/plain'
ngx.header['Set-Cookie'] = 'uid=2019-9999'

ngx.say("your have no cookie, please visit again. ")


