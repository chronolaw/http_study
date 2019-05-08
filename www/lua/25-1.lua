-- Copyright (C) 2019 by chrono
-- digest algorithm

local resty_rsa = require "resty.rsa"
local resty_str = require "resty.string"

local scheme = ngx.var.scheme
if scheme ~= 'https' then
    --ngx.log(ngx.ERR, scheme)
    return ngx.redirect(
        'https://'..ngx.var.host..ngx.var.request_uri, 301)
end

local algo_name = ngx.var.arg_algo or 'sha256'

local ok, algo = pcall(require, 'resty.' .. algo_name)

if not ok then
    ngx.status = 400
    return ngx.say('no algorithm: ', algo_name)
end

local plain = ngx.var.arg_plain or '1234'

local ctx = algo:new()

ctx:update(plain)

ngx.say('usage: ' .. ngx.var.uri .. '?algo=xxx&plain=xxx\n')
ngx.say('algo  : ', algo_name)
ngx.say('plain : ', plain)
ngx.say('digest: ', resty_str.to_hex(ctx:final()))

