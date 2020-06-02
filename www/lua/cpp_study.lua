-- Copyright (C) 2020 by chrono

-- for cpp study at 2020 geektime

-- ./run.sh reload
-- curl '127.1/cpp_study?token=cpp@2020' -d 'abcd'
-- tail logs/error.log

if ngx.req.get_method() ~= 'POST' then
    ngx.exit(400)
end

local token = ngx.var.arg_token

if token ~= 'cpp@2020' then
    ngx.exit(403)
end

ngx.req.read_body()

local data = ngx.req.get_body_data()

if not data then
    local name = ngx.req.get_body_file()

    local f = io.open(name, "r")
    data = f:read("*a")
    f:close()
end

assert(data)

ngx.log(ngx.ERR, "cpp_study data : ", data)

