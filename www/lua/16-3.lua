-- Copyright (C) 2019 by chrono

-- chunked range

--[[
GET /16-2 HTTP/1.1
Host: www.chrono.com
Range: bytes=0-9, 20-29

--xyz
Content-Type: text/plain
Content-Range: bytes 0-9/90

// this is
--xyz
Content-Type: text/plain
Content-Range: bytes 20-29/90

ext json d
--xyz--
--]]

--ngx.header['Content-Type'] = 'text/plain'
--ngx.header['Transfer-Encoding'] = 'chunked'

ngx.header['Accept-Ranges'] = 'bytes'
ngx.header['Content-Type'] = 'multipart/byteranges; boundary=xyz'

-- simulate chuned multipart
local strs = {
-- 1st part
[[
--xyz
Content-Type: text/plain
Content-Range: bytes 0-9/90

// this is
]],

-- 2nd part
[[
--xyz
Content-Type: text/plain
Content-Range: bytes 20-29/90

ext json d
]],

-- last part
[[
--xyz--
]]
}

-- flush for chunked
for _,v in ipairs(strs) do
    ngx.print(v)
    ngx.flush(true)
end

