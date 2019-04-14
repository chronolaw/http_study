-- Copyright (C) 2019 by chrono

local misc = ngx.shared.misc

local time = tonumber(misc:get("time"))

if not time then
    time = ngx.time()
    misc:set("time", time, 10)   -- seconds
end

local str = "HTTP Conditional Request \n" ..
            "Now is " .. ngx.http_time(time)

ngx.header['Content-Length'] = #str
ngx.header['Content-Type'] = 'text/plain'

ngx.header['Last-Modified'] = ngx.http_time(time)

-- see ngx_http_set_etag() in ngx_http_core_module.c
ngx.header['ETag'] = string.format('"%x-%x"', time, #str)

-- checked by ngx_http_not_modified_filter_module

--local http_time = ngx.var.http_if_modified_since
--if time == ngx.parse_http_time(http_time or "") then
--    ngx.exit(304)
--end

ngx.print(str)

