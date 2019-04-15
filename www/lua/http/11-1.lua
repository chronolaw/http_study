-- Copyright (C) 2019 by chrono

local strs = {}

strs[#strs + 1] = ngx.var.scheme .. "://" ..
                  ngx.var.host .. ":" ..
                  ngx.var.server_port ..
                  ngx.var.request_uri .. '\n'

strs[#strs + 1] = "scheme => " .. ngx.var.scheme
strs[#strs + 1] = "host   => " .. ngx.var.host
strs[#strs + 1] = "port   => " .. ngx.var.server_port
strs[#strs + 1] = "path   => " .. ngx.var.uri
strs[#strs + 1] = "query  => " .. (ngx.var.args or "")

local str = table.concat(strs, '\n')

ngx.header['Content-Length'] = #str
--ngx.header['Content-Type'] = 'text/plain'

ngx.print(str)
