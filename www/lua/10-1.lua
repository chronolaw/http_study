-- Copyright (C) 2019 by chrono

local str = "10-1 GET&HEAD test\n"

local method = ngx.req.get_method()

if method ~= "GET" and
   method ~= "HEAD" then

   ngx.exit(405)
end

ngx.header.content_length = #str

--if method == "HEAD" then
-- do nothing
--end

if method == "GET" then
    ngx.print(str)
end
