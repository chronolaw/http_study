-- Copyright (C) 2019 by chrono

if ngx.get_phase() ~= 'header_filter' then
    return
end

local cache_status = ngx.var.upstream_cache_status
local accel = ngx.var.http_host or ngx.var.server_name

ngx.header['X-Cache'] = cache_status
ngx.header['X-Accel'] = accel


-- hit rate
local misc = ngx.shared.misc

local total = misc:incr('total_req', 1, 0)
local hit = misc:get('hit') or 0

if cache_status == 'HIT' then
    hit = misc:incr('hit', 1, 0)
end

local rate = hit * 100 / total
ngx.header['X-Hit'] = string.format('%.2f%%', rate)

