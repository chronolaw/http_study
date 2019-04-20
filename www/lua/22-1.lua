-- Copyright (C) 2019 by chrono

--local ssl = require "ngx.ssl"

local bit = require "bit"
local band = bit.band

local ffi = require "ffi"
local ffi_new = ffi.new
local ffi_gc = ffi.gc
local ffi_copy = ffi.copy
local ffi_str = ffi.string
local C = ffi.C

ffi.cdef[[
typedef struct ssl_method_st SSL_METHOD;
typedef struct ssl_st SSL;
typedef struct ssl_ctx_st SSL_CTX;

const char *OpenSSL_version(int type);
const SSL_METHOD *TLS_method(void);
SSL_CTX *SSL_CTX_new(const SSL_METHOD *meth);
void SSL_CTX_free(SSL_CTX *ctx);
SSL *SSL_new(SSL_CTX *ctx);
void SSL_free(SSL *ssl);

const char *SSL_get_cipher_list(const SSL *s, int n);
char *SSL_get_shared_ciphers(const SSL *s, char *buf, int len);
]]

local openssl_ver = ffi_str(C.OpenSSL_version(0))

ngx.log(ngx.INFO, "hello openssl")

ngx.say('hello ', openssl_ver)

--ngx.say('\nver: ', ssl.get_tls1_version_str())

ngx.say('\nprotocol: ', ngx.var.ssl_protocol)

ngx.say('\nclient suites: ', ngx.var.ssl_ciphers)

ngx.say('\nserver suite: ', ngx.var.ssl_cipher)

local ssl_ctx = C.SSL_CTX_new(C.TLS_method())
local ssl = C.SSL_new(ssl_ctx)

--local cipher_list = C.SSL_get_cipher_list(ssl, 0)
--ngx.say('list 0: ', ffi_str(cipher_list))

--local buf = ffi_new('char[?]', 4096)
--C.SSL_get_shared_ciphers(ssl, buf, 4096)
--ngx.say('list: ', ffi_str(buf))

ngx.say('\nall suites in server:\n')

for i=0,60 do
    local cipher_list = C.SSL_get_cipher_list(ssl, i)

    if cipher_list == ffi.null then
        break
    end

    ngx.say('suite ', i, ': ', ffi_str(cipher_list))
end

C.SSL_free(ssl)
C.SSL_CTX_free(ssl_ctx)

