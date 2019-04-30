-- Copyright (C) 2019 by chrono
-- aes encrypt and decrypt

local resty_aes = require "resty.aes"
local resty_rsa = require "resty.rsa"
local resty_str = require "resty.string"

local ffi = require "ffi"
local ffi_null = ffi.null
local ffi_cdef = ffi.cdef
local ffi_typeof = ffi.typeof
local ffi_new = ffi.new
local ffi_C = ffi.C

local scheme = ngx.var.scheme
if scheme ~= 'https' then
    return ngx.redirect(
        'https://'..ngx.var.host..ngx.var.request_uri, 301)
end

if not pcall(ffi_typeof, "struct timeval") then
    ffi_cdef[[
    struct timeval {
        long int tv_sec;
        long int tv_usec;
    };

    int gettimeofday(struct timeval *tv, void *tz);
    ]]
end

local timeval_t = ffi_typeof("struct timeval")
local tm = ffi_new(timeval_t)
local now = ffi_new(timeval_t)

local count = tonumber(ngx.var.arg_count or 1000)

---- aes_cbc

local plain = 'hello openssl'

local key = 'a_key_for_aes'
local aes_128_cbc_md5 = resty_aes:new(key)

ffi_C.gettimeofday(tm, ffi_null)

local enc, dec

for i = 1, count do
    enc = aes_128_cbc_md5:encrypt(plain)
    dec = aes_128_cbc_md5:decrypt(enc)
end

ffi_C.gettimeofday(now, ffi_null)

ngx.print('aes_128_cbc enc/dec ', count, ' times : ')
--ngx.print(tonumber(now.tv_sec) - tonumber(tm.tv_sec), 's ')
--ngx.print(tonumber(now.tv_usec) - tonumber(tm.tv_usec), 'us\n')

local aes_time = (tonumber(now.tv_sec) * 1000 + tonumber(now.tv_usec) / 1000) -
                 (tonumber(tm.tv_sec) * 1000 + tonumber(tm.tv_usec) / 1000)

ngx.say(string.format('%.02fms\n', aes_time))

-- rsa 1024

local rsa_public_key = [[
-----BEGIN RSA PUBLIC KEY-----
MIGJAoGBALRafyXmEY9wBw/lvedQIjP8ZYPEY45S9pqOGYNyQoXAOVEQIMSv5eo2
rgWFREdp2tw25PDjL6+KF3D7sAPUI1j/Nyxq17xcUrFHskKyNnMKJpxHTDrrZmFD
GDj2oWw4kwRL9+m8mhpcFB0qkkJ66q3eb9bqJA7frZxsCRPDW52VAgMBAAE=
-----END RSA PUBLIC KEY-----
]]

local rsa_priv_key =[[
-----BEGIN RSA PRIVATE KEY-----
MIICXwIBAAKBgQC0Wn8l5hGPcAcP5b3nUCIz/GWDxGOOUvaajhmDckKFwDlRECDE
r+XqNq4FhURHadrcNuTw4y+vihdw+7AD1CNY/zcsate8XFKxR7JCsjZzCiacR0w6
62ZhQxg49qFsOJMES/fpvJoaXBQdKpJCeuqt3m/W6iQO362cbAkTw1udlQIDAQAB
AoGBAKpzuSWlakVJWLNSq4dZeenuCjddvcW+bSknUb+klnB4evM9LesWX1JbeV7o
U962kc186CUuYlwiRANZLEKCFSCqQ50KxotT3lZWdcvcQTh625hIPQAPJ5L3UGjx
I1er83KmDeoxk07wNAjmYrTnYXrRxaknJd6/65ke4XeQarBBAkEA3YJ5zvI+sJTp
JrkKnm9U/kZRMcM0QRQLw2iMR58vXmgl+xSOHdtaHs3fylq/xhCh5HlEUeqOrYmN
G6Ci6p+IMQJBANBvgiN1rHKT7M140rEvwIKJf2W+wU2Sf/VkJS6OE+eGb0tzZTYD
s4g3QLFnqPQrUsZ94NGFi8tQ8fJKbsOWtqUCQQDL0pNi6WTl9x/SkdJDlw4OK4Xq
1EPw3hE07a6m+MMNi6fnMTLUJlL2pVmXSYnNJuDQ6wUCm2JOLJO7KETAv6sBAkEA
orUZGsMmHb8ZkH/rwMMs/PmGiI8y6HIfDxjg6YmhQg+wW262KEcVY5T2HEZ2Hjyf
fjEPSZ99M/Z5GBFAi8/fvQJBAIMGwpXeDRi2GPhxdql1YEh8fanCq0Rz4teee6+m
emH+NTGnX6plyikqghnE8RAoR9TMsXR9Eg/KWvblxXS8/V4=
-----END RSA PRIVATE KEY-----
]]

local pub, err = resty_rsa:new({ public_key = rsa_public_key })
local priv, err = resty_rsa:new({ private_key = rsa_priv_key })

ffi_C.gettimeofday(tm, ffi_null)

for i = 1, count do
    enc = pub:encrypt(plain)
    dec = priv:decrypt(enc)
end

ffi_C.gettimeofday(now, ffi_null)

ngx.print('rsa_1024 enc/dec ', count, ' times : ')
--ngx.print(tonumber(now.tv_sec) - tonumber(tm.tv_sec), 's ')
--ngx.print(tonumber(now.tv_usec) - tonumber(tm.tv_usec), 'us\n')

local rsa_time = (tonumber(now.tv_sec) * 1000 + tonumber(now.tv_usec) / 1000) -
                 (tonumber(tm.tv_sec) * 1000 + tonumber(tm.tv_usec) / 1000)

ngx.say(string.format('%.02fms\n', rsa_time))

-- ratio

ngx.say(string.format('rsa/aes ratio = %.02f', rsa_time / aes_time))
