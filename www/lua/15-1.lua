-- Copyright (C) 2019 by chrono

local file = ngx.var.arg_name

if not file then
    local str = "You need use URI which looks like '/15-1?name=file'\n"

    ngx.header['Content-Length'] = #str
    --ngx.header['Content-Type'] = 'text/plain'

    ngx.print(str)
    return
end

local path = "/mime/" .. file
--ngx.log(ngx.ERR, "exec " .. path)

-- redirect to internal /mime
return ngx.exec(path)
