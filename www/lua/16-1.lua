-- Copyright (C) 2019 by chrono

local misc = ngx.shared.misc

--local close = ngx.var.arg_close or '0'

local counter = 1

if misc then
    counter = misc:incr("counter", 1, 0, 30)
end

local str = "keep alive data ".. counter .." \n"

--if close == '1' then
--    misc:set("counter", 0)
--    ngx.header['Connection'] = 'close'
--end

ngx.header['Content-Length'] = #str
--ngx.header['Content-Type'] = 'text/plain'

ngx.print(str)

--local conn = ngx.header['Connection']
--ngx.log(ngx.ERR, "conn = ", conn)
--
--if conn == 'close' then
--    misc:set("counter", 0)
--end

--if close == '1' then
--    ngx.flush(true)
--
--    local sock = ngx.req.socket(true)
--    sock:close()
--end
