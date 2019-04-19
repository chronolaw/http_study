-- Copyright (C) 2019 by chrono

-- multipart/byteranges; boundary

local boundary = string.format('%x', ngx.time())

ngx.header['Content-Type'] = 'multipart/byteranges; boundary=' .. boundary
--ngx.header['Transfer-Encoding'] = 'chunked'

local str
for i=1,3 do
    str = str .. '--' .. boundary .. '\r\n'
    str = str .. ('multipart/byteranges data ' .. i .. '\n')
end

str = str .. '--'

ngx.status = 416
ngx.header['Content-Length'] = #str

ngx.print(str)
