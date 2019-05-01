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
    ]]

    if jit.os == 'Linux' then
        ffi_cdef[[
        // linux
        int gettimeofday(struct timeval *tv, void *tz);
        ]]
    else
        ffi_cdef[[
        // windows
        int ngx_gettimeofday(struct timeval *tv);
        ]]
    end
end

local function ngx_gettimeofday(tv)
    if jit.os == 'Linux' then
        return ffi_C.gettimeofday(tv, ffi_null)
    else
        return ffi_C.ngx_gettimeofday(tv)
    end
end

local timeval_t = ffi_typeof("struct timeval")
local tm = ffi_new(timeval_t)
local now = ffi_new(timeval_t)

local function clock_start()
    ngx_gettimeofday(tm)
end

local function clock_elasped()
    ngx_gettimeofday(now)
    return (tonumber(now.tv_sec) - tonumber(tm.tv_sec)) * 1000 +
           (tonumber(now.tv_usec) - tonumber(tm.tv_usec)) / 1000
end

local count = tonumber(ngx.var.arg_count or 1000)

---- aes_cbc

local plain = 'hello openssl'
local data_len = #plain * count

ngx.say('plain = ', plain)
ngx.say('count = ', count, '\n')

local key = 'a_key_for_aes'
local aes_128_cbc_md5 = resty_aes:new(key)

--ngx_gettimeofday(tm)
clock_start()

local enc, dec

for i = 1, count do
    enc = aes_128_cbc_md5:encrypt(plain)
    dec = aes_128_cbc_md5:decrypt(enc)
end

--ngx_gettimeofday(now)
local aes_time = clock_elasped()

ngx.print('aes_128_cbc enc/dec ', count, ' times : ')
--ngx.print(tonumber(now.tv_sec) - tonumber(tm.tv_sec), 's ')
--ngx.print(tonumber(now.tv_usec) - tonumber(tm.tv_usec), 'us\n')

--local aes_time = (tonumber(now.tv_sec) * 1000 + tonumber(now.tv_usec) / 1000) -
--                 (tonumber(tm.tv_sec) * 1000 + tonumber(tm.tv_usec) / 1000)
--local aes_time = (tonumber(now.tv_sec) - tonumber(tm.tv_sec)) * 1000 +
--                 (tonumber(now.tv_usec) - tonumber(tm.tv_usec)) / 1000

ngx.say(string.format('%.02fms, %.02fMB/s\n', aes_time, data_len / aes_time / 1024))
ngx.flush(true)
ngx.sleep(0)

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

--ngx_gettimeofday(tm)
clock_start()

for i = 1, count do
    enc = pub:encrypt(plain)
    dec = priv:decrypt(enc)
end

--ngx_gettimeofday(now)
local rsa_time = clock_elasped()

ngx.print('rsa_1024 enc/dec ', count, ' times : ')
--ngx.print(tonumber(now.tv_sec) - tonumber(tm.tv_sec), 's ')
--ngx.print(tonumber(now.tv_usec) - tonumber(tm.tv_usec), 'us\n')

--local rsa_time = (tonumber(now.tv_sec) * 1000 + tonumber(now.tv_usec) / 1000) -
--                 (tonumber(tm.tv_sec) * 1000 + tonumber(tm.tv_usec) / 1000)
--local rsa_time = (tonumber(now.tv_sec) - tonumber(tm.tv_sec)) * 1000 +
--                 (tonumber(now.tv_usec) - tonumber(tm.tv_usec)) / 1000

ngx.say(string.format('%.02fms, %.02fKB/s\n', rsa_time, data_len / rsa_time))
ngx.flush(true)

-- ratio

ngx.say(string.format('rsa_1024/aes ratio = %.02f\n', rsa_time / aes_time))
ngx.flush(true)
ngx.sleep(0)

-- rsa 2048

--[[
local rsa_public_key, rsa_priv_key, err = resty_rsa:generate_rsa_keys(2048)
if not rsa_public_key then
    ngx.say('generate rsa keys err: ', err)
end

ngx.say(rsa_public_key)
ngx.say(rsa_priv_key)
--]]

local rsa_public_key = [[
-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAv7ZuHcxFfwPqicpsxXuXmcCE4fauuDNO+FiiM2c6fzgpELP6unyl
UWLqENPkGkQ2NmhG9qvENPB5DQVTxWVeSHGjYh8ap9VahoHTmmgUyx6r9ofi8H3e
k1WcOF7VQlnqzZ9RmVZgFH/jd5m+h9M1FqdDS069MvvcJvjY0iHRHTs4MMNepqv8
blawM7uD4OhXMqCIyjCC6RDznnWExPMRbkN7Nabc2HFUfuK4qXGRUZNHhDMD7Btw
osJjk5qIhDCuWP9KJdDRrglyP2/IxR/U5ee9vNajw/1coX5+AhaLDf06yOnXNu3/
uK965P8kM/SDczm783jWfiCiv3C4vDnZXwIDAQAB
-----END RSA PUBLIC KEY-----
]]

local rsa_priv_key =[[
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAv7ZuHcxFfwPqicpsxXuXmcCE4fauuDNO+FiiM2c6fzgpELP6
unylUWLqENPkGkQ2NmhG9qvENPB5DQVTxWVeSHGjYh8ap9VahoHTmmgUyx6r9ofi
8H3ek1WcOF7VQlnqzZ9RmVZgFH/jd5m+h9M1FqdDS069MvvcJvjY0iHRHTs4MMNe
pqv8blawM7uD4OhXMqCIyjCC6RDznnWExPMRbkN7Nabc2HFUfuK4qXGRUZNHhDMD
7BtwosJjk5qIhDCuWP9KJdDRrglyP2/IxR/U5ee9vNajw/1coX5+AhaLDf06yOnX
Nu3/uK965P8kM/SDczm783jWfiCiv3C4vDnZXwIDAQABAoIBAQC0jkFZaRiOzoZm
7bHRsFwQX2QHWQgmzZPzi65/0Roj1SW/6HIcjuY4J3uhC58KKfIQ/dbP3Of2oACy
BbFm+Nh6TCR/diHpraQLiFxdUOc8gg+dKU/QBgvJIVj3MkGRsxPUQtdcHiBxTh1S
eAcc7wtR4YgcdfT0/oXSYo36IgVLi+gWgRDcQMGwPJx/Qts5WbJlfWmDI+zZ8Z5y
5VvNQCWfgCKmC74oeP3QEJVpU6lZp7nSgSsIM+83CiSs5NSftdCJhS5PA7qicuyT
Qzs/OpB7Vk0axKsmuG9XLMtK/aARdUESqBwuh4LlEcwpLfQS5Z9BW4q5OOH1P0UP
wLORt2TxAoGBAOTEJ/TgiZ789BBKnmlE2lDD19pKGc7hvCOh+3PksTnRji8taeaJ
iFeoAW/S3Zvsb/ODsYhlcmw5QXB8lSW8fUfbiDy+B2ozwO1eGKpPRUT1b+qHetPF
Wb+TT48n9bF5fndaL/mkJxU+wqYPa9YN3fymdc+ey8OSHuPsm/OZjQ65AoGBANaJ
CKmg5iWUVNS555gfTPLnvoUlmGj1UyS8QsrogtS25qtBXGMrHbO1lfzZ3/43MwQx
kT20fr1JIngiodJMKN/4h06v7vUrjDto14vQJrAVVi6soYu4VNN+aFM2Jo+VQtmD
t1HQfnf8CzHaDNcaFyGoUUBDBpLLfB4yWKlFOFzXAoGBANoLAM6NKX7pOLNCfAR4
BOHQGK/NyxV94LXR0Xqf8i/axXu//F0on1R1JJFx2ZmhXP8seY04rDvswqu1gu8J
3hscapkCwsx98ZgNBNNnZO2aRgazBOZOBwHrJXycKLj0xQ57XpjB1iKQxDRFJJJM
e1YxTr8KasrIPjseLXKc2265AoGAe1NnIWwXIT81zNvZoH9N0s0ZnpzQEnYEh7eZ
hd9HZlSGIah/HZrphic6w5HTy+WbdCuyXJBn0xQ5tmniMGwLi0TpM3i7m0Cfan+I
eRz9QHfjhQ1ECHe8e5/NBRi57gxV04h+V4/NQ9gl71Bz1StwZK7HlnNxUe2buhgj
E5txHR0CgYEA0JE8z8kM3qCKO3RqF+xUQbJGeb5oqtRRC1O1sU9Ovc8u863tvghv
3QAa9+WhwW5LtX3Ey5rkBicSEQC2LU1aWiiAnhWdBzsVt8ydto+JYsw7qce0rjHM
NFN6HSMLlAWgq2ggkeT5h/btVflm6EyCIqr7LuXGQ5CqXK9tMaISM6o=
-----END RSA PRIVATE KEY-----
]]

local pub, err = resty_rsa:new({ public_key = rsa_public_key })
local priv, err = resty_rsa:new({ private_key = rsa_priv_key })

--ngx_gettimeofday(tm)
clock_start()

for i = 1, count do
    enc = pub:encrypt(plain)
    dec = priv:decrypt(enc)
end

--ngx_gettimeofday(now)
local rsa_time = clock_elasped()

ngx.print('rsa_2048 enc/dec ', count, ' times : ')

--local rsa_time = (tonumber(now.tv_sec) * 1000 + tonumber(now.tv_usec) / 1000) -
--                 (tonumber(tm.tv_sec) * 1000 + tonumber(tm.tv_usec) / 1000)
--local rsa_time = (tonumber(now.tv_sec) - tonumber(tm.tv_sec)) * 1000 +
--                 (tonumber(now.tv_usec) - tonumber(tm.tv_usec)) / 1000

ngx.say(string.format('%.02fms, %.02fKB/s\n', rsa_time, data_len / rsa_time))

-- ratio
ngx.say(string.format('rsa_2048/aes ratio = %.02f\n', rsa_time / aes_time))
