-- Copyright (C) 2019 by chrono

local headers = ngx.req.get_headers()

local raw_headers = 'N/A for HTTP/2'
--ngx.log(ngx.ERR, 'http2=[',ngx.var.http2,']')
if #ngx.var.http2 == 0 then
    raw_headers = ngx.req.raw_header()
end

local str = {}

for k,v in pairs(headers) do
    --ngx.say(k, "\t\t\t\t=>", v)
    --ngx.say(string.format("%-10s=>", k))
    local s = string.format("%-10s=>", k)

    if type(v) == 'string' then
        --ngx.say(v)
        s = s .. v
    else
        --ngx.say(table.concat(v, ' '))
        s = s .. table.concat(v, ',')
    end

    str[#str + 1] = s
end

str[#str + 1] = "\nraw header is :\n"

str = table.concat(str, '\n')

--ngx.header['Content-Type'] = 'text/plain'
ngx.header['Content-Length'] = #str + #raw_headers

ngx.print(str)
ngx.print(raw_headers)

--ngx.say("\nraw header is :\n")
--ngx.say(ngx.req.raw_header())
