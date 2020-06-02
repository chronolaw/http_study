# Copyright (C) 2019 by chrono


    # for lesson 15
    # curl 127.1/mime
    location /mime/ {
        internal;
        alias   mime/;
    }

    # proxy pass to origin
    location  /proxy/ {
        # gzip + vary
        #gzip on;
        #gzip_vary on;

        internal;

        add_header  Via $host:$server_port;

        #proxy_set_header Host $host;
        #proxy_http_version 1.1;

        proxy_set_header X-Real-IP          $remote_addr:$remote_port;
        proxy_set_header X-Forwarded-Host   $http_host;
        proxy_set_header X-Forwarded-Proto  $scheme;
        proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;

        proxy_pass http://origin.io;
    }

    # proxy cache
    location  /proxy_cache/ {
        internal;

        #enable cache
        proxy_cache www_cache;
        proxy_cache_use_stale error timeout;

        proxy_pass http://origin.io;

        #add_header  X-Cache $upstream_cache_status;
        #add_header  X-Accel $server_name;
        header_filter_by_lua_file lua/cache_filter.lua;
    }

    # curl 127.1/07-1
    location ~ ^/([\d|\-]+) {
        default_type text/plain;
        content_by_lua_file lua/$1.lua;
    }

    # for cpp study in geektime
    # curl 127.1/cpp_study
    location = /cpp_study {
        default_type text/plain;
        content_by_lua_file lua/cpp_study.lua;
    }

    location /gc {
        content_by_lua_block {
            ngx.say(string.format("GC: %dKB", collectgarbage("count")))
        }
    }

