-- Copyright (C) 2019 by chrono

local path = "/proxy/"
--ngx.log(ngx.ERR, "exec " .. path)

-- redirect to internal /mime
return ngx.exec(path)
