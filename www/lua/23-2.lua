-- Copyright (C) 2019 by chrono

local resty_rsa = require "resty.rsa"
local resty_str = require "resty.string"

local time = ngx.now()

local rsa_public_key, rsa_priv_key, err = resty_rsa:generate_rsa_keys(1024)
if not rsa_public_key then
    ngx.say('generate rsa keys err: ', err)
end

ngx.say('rsa1024 genkey time = ', ngx.now() - time, 's\n')

ngx.say(rsa_public_key)

ngx.say(rsa_priv_key)

local pub, err = resty_rsa:new({ public_key = rsa_public_key })
local priv, err = resty_rsa:new({ private_key = rsa_priv_key })

local priv, err = resty_rsa:new({ private_key = rsa_priv_key })

local plain = 'hello openssl'
local enc = pub:encrypt(plain)
local dec = priv:decrypt(enc)

ngx.say('plain = ', plain)
ngx.say('enc   = ', resty_str.to_hex(enc))
ngx.say('dec   = ', dec)
