#!/usr/bin/python
'''
Copyright 2018 Albert Monfa

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
'''

import sys
import os
import inspect
from os import environ

sys.path.append('{}/../client/'.format(os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))))
from ClientDownload import ClientDownload
from ClientStatus import ClientStatus
from ClientDelete import ClientDelete
from ClientUpload import ClientUpload


if "BANHMI_URL_BASE" not in os.environ:
    print('BANHMI_URL_BASE env var is must')
    sys.exit(-1)

if "BANHMI_TEST_BUCKET" not in os.environ:
    print('BANHMI_URL_BASE env var is must')
    sys.exit(-1)

bucket = os.environ["BANHMI_TEST_BUCKET"]
key = 'foo'
path = '/tmp/output.dat.download'
path_upload = '/tmp/output.dat'
host = os.environ["BANHMI_URL_BASE"]

with open(path_upload, "wb") as out:
    out.truncate(1024 * 1024)

foo = ClientUpload()
res = foo.mp_upload(bucket, key, host, path_upload)
print(res)

foo = ClientStatus()
res = foo.status(bucket, key, host)
print(res)

foo = ClientDownload()
res = foo.download(bucket, key, host, path)
print(res)

foo = ClientDelete()
res = foo.delete(bucket, key, host)
print(res)

foo = ClientStatus()
res = foo.status(bucket, key, host)
print(res)

sys.exit(0)
