-- Copyright (C) 2019 by chrono

local ngx_resp = require 'ngx.resp'

local cookie = ngx.var.http_cookie

--ngx.header['Content-Type'] = 'text/plain'

if cookie then
    ngx.say("your cookie is [", cookie, "]\n")
    return
end

-- session cookie
--local fields = {
--    'sessionid=' .. ngx.time(),
--    'Max-Age=5'
--}

--ngx.header['Set-Cookie'] = table.concat(fields, '; ')

ngx_resp.add_header('Set-Cookie', 'sessionid=s' .. ngx.time())
ngx_resp.add_header('Set-Cookie', 'logintime=' .. ngx.http_time(ngx.time()))

ngx.say("your have no cookie, please visit again.")

