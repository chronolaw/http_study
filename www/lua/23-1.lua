-- Copyright (C) 2019 by chrono
-- aes encrypt and decrypt

local resty_aes = require "resty.aes"
local resty_str = require "resty.string"

local scheme = ngx.var.scheme
if scheme ~= 'https' then
    return ngx.redirect(
        'https://'..ngx.var.host..ngx.var.request_uri, 301)
end

local key = ngx.var.arg_key
local salt = ngx.var.arg_salt

if not key then
    ngx.say('yout must submit a key for cipher')
    return ngx.exit(400)
end

local aes_128_cbc_md5 = resty_aes:new(key, salt)

local plain = 'hello openssl'
local enc = aes_128_cbc_md5:encrypt(plain)
local dec = aes_128_cbc_md5:decrypt(enc)

ngx.say('plain = ', plain)
ngx.say('enc   = ', resty_str.to_hex(enc))
ngx.say('dec   = ', dec)
