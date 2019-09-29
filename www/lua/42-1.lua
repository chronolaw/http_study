-- Copyright (C) 2019 by chrono

--#!/usr/local/openresty/bin/resty

ngx.say('DH demo\n')

local P = 17
local G = 5

ngx.say("public:")
ngx.say("P = ", P)
ngx.say("G = ", G)
ngx.say("")

local a = 10
local b = 5

ngx.say("private:")
ngx.say("a = ", a)
ngx.say("b = ", b)
ngx.say("")

local A = (G ^ a) % P
local B = (G ^ b) % P

ngx.say("public:")
ngx.say("A = (G ^ a % P) = ", A)
ngx.say("B = (G ^ b % P) = ", B)
ngx.say("")

local shared_a = (B ^ a) % P
local shared_b = (A ^ b) % P

ngx.say("private:")
ngx.say("shared_a = (B ^ a % P) = ", shared_a)
ngx.say("shared_b = (A ^ b % P) = ", shared_b)
ngx.say("B ^ a = (G ^ b ) ^ a = (G ^ a) ^ b = A ^ b (ignore 'mod P')")
