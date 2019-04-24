-- Copyright (C) 2019 by chrono

local misc = ngx.shared.misc

local key = ngx.var.http_host .. "time"
local time = tonumber(misc:get(key))

if not time then
    time = ngx.time()
    misc:set(key, time, 30)   -- seconds
end

local str = "HTTP Original Server\n" ..
            "Now is " .. ngx.http_time(time) ..
            "\n\n"

local fields = {'X-Real-IP', 'X-Forwarded-Host',
                'X-Forwarded-Proto', 'X-Forwarded-For'}

local headers = ngx.req.get_headers()
for _,v in ipairs(fields) do
    str = str .. v .. " => " .. headers[v] .. "\n"
end

ngx.header['Content-Length'] = #str
ngx.header['X-Powered-By'] = 'ngx_lua_' .. ngx.config.ngx_lua_version
--ngx.header['Content-Type'] = 'text/plain'

ngx.header['Origin'] = ngx.var.scheme .. "://" ..
                       ngx.var.host .. ":" ..
                       ngx.var.server_port

ngx.header['Cache-Control'] = 'public, max-age=10, s-maxage=30'
--ngx.header['Expires'] = ngx.http_time(time + 10)

ngx.header['Last-Modified'] = ngx.http_time(time)
ngx.header['ETag'] = string.format('"%x-%x"', time, #str)

ngx.print(str)

