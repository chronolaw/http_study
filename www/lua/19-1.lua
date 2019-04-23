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

local time = tostring(ngx.time())

ngx_resp.add_header('Set-Cookie', 'sid=' .. string.sub(time, -4, -1))
ngx_resp.add_header('Set-Cookie', 'system=' .. jit.os ..'_'..jit.arch)

ngx.say("your have no cookie, please visit again.")

