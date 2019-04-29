-- Copyright (C) 2019 by chrono

local misc = ngx.shared.misc

local key = ngx.var.http_host .. "time"
local time = misc:get(key)

if not time then
    time = ngx.time()
    misc:set(key, time, 30)   -- seconds
end

local str = "HTTP Original Server\n" ..
            "ID is " .. string.sub(time, -4, -1) .. '\n' ..
            --"Now is " .. ngx.http_time(time) ..
            "\n\n"

--ngx.header['X-Powered-By'] = 'ngx_lua_' .. ngx.config.ngx_lua_version
--ngx.header['Content-Type'] = 'text/plain'

ngx.header['Origin'] = ngx.var.scheme .. "://" ..
                       ngx.var.host .. ":" ..
                       ngx.var.server_port

local need_cache = string.find(ngx.var.uri, 'cache')

if need_cache then
    -- proxy cache
    ngx.header['Cache-Control'] = 'public, max-age=10, s-maxage=30'
    --ngx.header['Expires'] = ngx.http_time(time + 10)

    --ngx.header['Last-Modified'] = ngx.http_time(time)
    ngx.header['ETag'] = string.format('"%x-%x"', time, #str)
else
    -- only proxy
    local fields = {'X-Real-IP', 'X-Forwarded-For',
                    'X-Forwarded-Host', 'X-Forwarded-Proto'}

    local headers = ngx.req.get_headers()
    for _,v in ipairs(fields) do
        str = str .. v .. " => " .. (headers[v] or 'nil') .. "\n"
    end
end

ngx.header['Content-Length'] = #str

ngx.print(str)

