-- Copyright (C) 2019 by chrono

local headers = ngx.req.get_headers()

for k,v in pairs(headers) do
    ngx.say(k, "=>", v)
end

ngx.say("raw header is :\n")
ngx.say(ngx.req.raw_header())
