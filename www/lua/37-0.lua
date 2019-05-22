-- Copyright (C) 2019 by chrono

local server = require "resty.websocket.server"

local wb, err = server:new{
    timeout = 5000,
    max_payload_len = 1024 * 64,
    }

if not wb then
    ngx.log(ngx.ERR, "failed to init websocket: ", err)

    ngx.status = 444
    return ngx.say("should not access by http!")
    --ngx.exit(444)
end

local data, typ, bytes, err

while true do
    data, typ, err = wb:recv_frame()

    if not data then
        if not string.find(err, "timeout", 1, true) then
            ngx.log(ngx.ERR, "failed to recv: ", err)
            ngx.exit(444)
        end
    end

    if typ == "close" then
        ngx.log(ngx.ERR, "closed with: ", err, " msg: ", data)

        bytes, err = wb:send_close()
        if not bytes then
            ngx.log(ngx.ERR, "failed to close: ", err)
        end
        ngx.exit(0)
    end

    if typ == "ping" then
        bytes, err = wb:send_pong()
        if not bytes then
            ngx.log(ngx.ERR, "failed to pong: ", err)
        end
    end

    if typ == "text" then
        bytes, err = wb:send_text( data..','..data)
        if not bytes then
            ngx.log(ngx.ERR, "failed to send: ", err)
        end
    end

    -- skip other type
end

