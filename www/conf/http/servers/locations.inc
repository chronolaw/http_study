# Copyright (C) 2019 by chrono


    # for lesson 15
    # curl 127.1/mime
    location /mime/ {
        internal;
        alias   mime/;
    }

    # proxy pass to orign
    location  /proxy/ {
        # gzip + vary
        #gzip on;
        #gzip_vary on;

        internal;

        #enable cache
        proxy_cache cache_one;
        add_header  Cache-Hit $upstream_cache_status;
        add_header  Via $host:$server_port;
        add_header  X-Accel $server_name;

        #proxy_set_header Host $host;
        #proxy_http_version 1.1;

        proxy_set_header X-Real-IP          $remote_addr:$remote_port;
        proxy_set_header X-Forwarded-Host   $host;
        proxy_set_header X-Forwarded-Proto  $scheme;
        proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;

        proxy_pass http://origin.io;
    }

    # curl 127.1/07-1
    location ~ ^/([\d|\-]+) {
        default_type text/plain;
        content_by_lua_file lua/$1.lua;
    }

    location /gc {
        content_by_lua_block {
            ngx.say(string.format("GC: %dKB", collectgarbage("count")))
        }
    }

