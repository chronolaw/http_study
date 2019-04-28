-- Copyright (C) 2019 by chrono

local path = "/proxy_cache/"
--ngx.log(ngx.ERR, "exec " .. path)

-- redirect to internal /proxy_cache/
return ngx.exec(path)
