-- Copyright (C) 2019 by chrono

local code = ngx.var.arg_code

local str = "Your expect code is " ..
            (code or "nil") .. '\n'

ngx.header.content_length = #str

ngx.status = tonumber(code) or 400

ngx.print(str)
