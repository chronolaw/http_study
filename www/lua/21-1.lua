-- Copyright (C) 2019 by chrono

local path = "/proxy/"
--ngx.log(ngx.ERR, "exec " .. path)

-- redirect to internal /proxy
return ngx.exec(path)
