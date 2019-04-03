-- Copyright (C) 2019 by chrono

local code = ngx.var.arg_code or "nil"

--local str = "Your expect code is " ..
--            (code or "nil") .. '\n'

--ngx.header.content_length = #str

ngx.header['Expect-Code'] = code

--ngx.status = tonumber(code) or 400

--ngx.print(str)

code = tonumber(code) or 400

ngx.exit(code < 200 and 501 or code)
