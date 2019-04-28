-- Copyright (C) 2019 by chrono
-- sign and verify

local resty_rsa = require "resty.rsa"
local resty_str = require "resty.string"

local scheme = ngx.var.scheme
if scheme ~= 'https' then
    --ngx.log(ngx.ERR, scheme)
    return ngx.redirect(
        'https://'..ngx.var.host..ngx.var.request_uri, 301)
end

local algo_name = ngx.var.arg_algo or 'sha1'

local ok, algo = pcall(require, 'resty.' .. algo_name)

if not ok then
    ngx.status = 400
    return ngx.say('no algorithm: ', algo_name)
end

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

ngx.say('usage: ' .. ngx.var.uri .. '?algo=xxx&plain=xxx\n')
ngx.say(rsa_public_key)
ngx.say(rsa_priv_key)

local plain = ngx.var.arg_plain or '1234'

local priv, err = resty_rsa:new(
    { private_key = rsa_priv_key, algorithm = algo_name })
local pub, err = resty_rsa:new(
    { public_key = rsa_public_key, algorithm = algo_name })

local sig, err = priv:sign(plain)


ngx.say('algo  : rsa1024 with ', algo_name)
ngx.say('plain : ', plain)
ngx.say('signature: ', resty_str.to_hex(sig))
ngx.say('verify   : ', pub:verify(plain, sig))

