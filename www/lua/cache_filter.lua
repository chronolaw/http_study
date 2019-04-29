-- Copyright (C) 2019 by chrono

if ngx.get_phase() ~= 'filter' then
    return
end

local cache_status = ngx.var.upstream_cache_status

ngx.header['X-Cache'] = ngx.var.upstream_cache_status
ngx.header['X-Accel'] = ngx.var.server_name


-- hit rate
local misc = ngx.shared.misc

local total = misc:incr('total_req', 1)
local hit = misc:get('hit')

if cache_status == 'HIT' then
    hit = misc:incr('hit', 1)
end

ngx.header['X-Hit-Rate'] = hit / total

