-- Copyright (C) 2019 by chrono

local ngx_resp = require 'ngx.resp'

local cookie = ngx.var.http_cookie

--ngx.header['Content-Type'] = 'text/plain'

if cookie then
    ngx.say("your cookie is [", cookie, "]\n")
    return
end

-- session cookie
local fields = {
    'favorite=hamburger',
    'Max-Age=5'
}

ngx.header['Set-Cookie'] = table.concat(fields, '; ')

ngx.say("your have no cookie, please visit again.")

