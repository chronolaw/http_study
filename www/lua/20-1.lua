-- Copyright (C) 2019 by chrono

local time = 30

local now = ngx.time()

local str = "HTTP Cache Control\n" ..
            "ID is " .. string.sub(tostring(now), -4, -1) .. '\n' ..
            "This message will be cached for " .. time .. 's\n'


ngx.header['Content-Length'] = #str
--ngx.header['Content-Type'] = 'text/plain'

ngx.header['Cache-Control'] = 'max-age='..time  --', no-cache'

if ngx.var.arg_need_expires == '1' then
    ngx.header['Expires'] = ngx.http_time(now + 10)
end

ngx.print(str)

