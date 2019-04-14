-- Copyright (C) 2019 by chrono

local now = ngx.time()
local str = "HTTP Cache Control\n" ..
            "Now is " .. ngx.http_time(now)


ngx.header['Content-Length'] = #str
ngx.header['Content-Type'] = 'text/plain'

ngx.header['Cache-Control'] = 'public, max-age=10'

if ngx.var.arg_need_expires == '1' then
    ngx.header['Expires'] = ngx.http_time(now + 10)
end

ngx.print(str)

