-- Copyright (C) 2019 by chrono

-- range by ngx_http_range_filter_module

local path = "/mime/a.txt"

-- Accept-Ranges: bytes
if ngx.var.http_range then
    ngx.header['Accept-Ranges'] = 'bytes'
end

return ngx.exec(path)

-- simple imeplent for range parse

--[==[
local range = ngx.var.http_range

ngx.status = 400
str = "only test for range request\n"

-- check range header
if not range then
    ngx.header['Content-Length'] = #str

    return ngx.print(str)
end
--ngx.log(ngx.ERR, "range is: ", range)

str = "range field error\n"

-- check range format
local m = ngx.re.match(range, [[bytes=(\d+)-(\d+)]], "ijo")
--ngx.log(ngx.ERR, "re is: ", m[0] or 'no re')
if not m then
    ngx.header['Content-Length'] = #str
    return ngx.print(str)
end

-- must be right format :a-b
local start_pos = tonumber(m[1])
local end_pos = tonumber(m[2])

if not start_pos or not end_pos or
   start_pos > end_pos then

    ngx.header['Content-Length'] = #str
    return ngx.print(str)
end

local range_num = end_pos - start_pos + 1
--local fake_content_length = range_num + 500

ngx.status = 416
str = "range too huge for test\n"

if range_num > 1000 then
    ngx.header['Content-Length'] = #str
    return ngx.print(str)
end

ngx.status = 206    -- partial content
ngx.header['Accept-Range'] = 'bytes'
ngx.header['Content-Range'] = 'bytes ' ..
                              start_pos ..
                              '-' ..
                              end_pos ..
                              '/' ..
                              range_num + 500

str = 'data:' .. string.rep('x', range_num - 5)
ngx.header['Content-Length'] = #str

ngx.print(str)
--]==]
