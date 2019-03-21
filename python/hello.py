#!/usr/bin/python

# Copyright (C) 2019 by chrono

import httplib

url = 'https://127.0.0.1/'

conn = httplib.HTTPConnection("127.0.0.1")
conn.request(method="GET", url=url)

response = conn.getresponse()
res = response.read()

print res

