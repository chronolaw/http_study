-- Copyright (C) 2019 by chrono

--#!/usr/local/openresty/bin/resty

ngx.say('DH demo\n')

local P = 7
local G = 3

ngx.say("P = ", P)
ngx.say("G = ", G)
ngx.say("")

local a = 4
local b = 5

ngx.say("a = ", a)
ngx.say("b = ", b)
ngx.say("")

local A = (G ^ a) % P
local B = (G ^ b) % P

ngx.say("A = ", A)
ngx.say("B = ", B)
ngx.say("")

local aa = (B ^ a) % P
local bb = (A ^ b) % P

ngx.say("aa = ", aa)
ngx.say("bb = ", bb)
