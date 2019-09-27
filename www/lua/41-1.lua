-- Copyright (C) 2019 by chrono

--#!/usr/local/openresty/bin/resty

ngx.say('DH demo\n')

local P = 17
local G = 5

ngx.say("P = ", P)
ngx.say("G = ", G)
ngx.say("")

local a = 10
local b = 5

ngx.say("a = ", a)
ngx.say("b = ", b)
ngx.say("")

local A = (G ^ a) % P
local B = (G ^ b) % P

ngx.say("A = ", A)
ngx.say("B = ", B)
ngx.say("")

local shared_a = (B ^ a) % P
local shared_b = (A ^ b) % P

ngx.say("shared_a = ", shared_a)
ngx.say("shared_b = ", shared_b)
