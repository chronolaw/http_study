-- Copyright (C) 2019 by chrono

local method = ngx.req.get_method()

--ngx.log(ngx.ERR, "method = ", method)

if method ~= "POST" and
   method ~= "PUT" then

   ngx.exit(405)
end

ngx.req.read_body()

local data = ngx.req.get_body_data()

if not data then
    --ngx.log(ngx.ERR, "method no data", method)
   ngx.exit(400)
end

--ngx.log(ngx.ERR, "data len = ", #data)

local str = "your [ " .. method .. " ] data is : "

ngx.header.content_length = #str + #data

ngx.print(str, data)

