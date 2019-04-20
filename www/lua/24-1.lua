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

local algo_name = ngx.var.arg_algo or 'md5'

local algo = require('resty.' .. algo_name)

if not algo then
    ngx.say('no algorithm: ', algo_name)
    return ngx.exit(400)
end

local plain = ngx.var.arg_text or '1234'

local ctx = algo:new()

ctx:update(plain)

ngx.say('algo  : ', algo_name)
ngx.say('plain : ', plain)
ngx.say('digest: ', resty_str.to_hex(ctx:final()))

