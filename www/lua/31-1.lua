-- Copyright (C) 2019 by chrono

local path = "/30-1"
--ngx.log(ngx.ERR, "exec " .. path)

return ngx.exec(path)
