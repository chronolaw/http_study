-- Copyright (C) 2019 by chrono
-- aes encrypt and decrypt

local resty_aes = require "resty.aes"
local resty_str = require "resty.string"

local ffi = require "ffi"
local C = ffi.C

-- try aes_gcm
ffi.cdef[[
const EVP_CIPHER *EVP_aes_128_ccm(void);
const EVP_CIPHER *EVP_aes_128_gcm(void);
]]

local scheme = ngx.var.scheme
if scheme ~= 'https' then
    return ngx.redirect(
        'https://'..ngx.var.host..ngx.var.request_uri, 301)
end

local key = ngx.var.arg_key
local plain = ngx.var.arg_plain or 'hello openssl'
local salt = ngx.var.arg_salt

if not key then
    ngx.status = 400
    return ngx.say('you must submit a key for cipher: '..
            ngx.var.uri .. '?key=xxx&plain=xxx'
            --'?key=xxx&salt=xxx'
            )
end

local cipher

--local gcm_func = C['EVP_aes_128_gcm']()
--if gcm_func then
--    cipher = {size = 128, cipher = 'gcm',
--              method = gcm_func}
--end

local aes_128_cbc_md5 = resty_aes:new(key, salt, cipher)

--local plain = 'hello openssl'
local enc = aes_128_cbc_md5:encrypt(plain)
local dec = aes_128_cbc_md5:decrypt(enc)

ngx.say('usage: ' .. ngx.var.uri .. '?key=xxx&plain=xxx\n')
ngx.say('algo  = aes_128_cbc')
ngx.say('plain = ', plain)
ngx.say('enc   = ', resty_str.to_hex(enc))
ngx.say('dec   = ', dec)
