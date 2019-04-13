-- Copyright (C) 2019 by chrono

local file = ngx.var.args

if not file then
    local str = "You need use URI like '/15-1?file'\n"

    ngx.header['Content-Length'] = #str
    ngx.header['Content-Type'] = 'text/plain'

    ngx.print(str)
    return
end

local path = "/mime/" .. file
--ngx.log(ngx.ERR, "exec " .. path)

-- redirect to internal /mime
return ngx.exec(path)
