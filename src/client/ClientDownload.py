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

import aiohttp
import asyncio

DEFAULT_CHUNK_SIZE = 128000
URL_PATTERN = '{0}/file/download?bucket={1}&key={2}'

class ClientDownload():

    def __init__(self, chunk_size=DEFAULT_CHUNK_SIZE):
        self.chunk_size = chunk_size

    def download(self, bucket, key, host, path=None):
        self.url = str(URL_PATTERN).format(host, bucket, key)

        async def downloader():
            self.session = aiohttp.ClientSession()
            if path is None:
                resp = await self.download_in_mem()
                await self.session.close()
                return resp
            else:
                resp = await self.download_in_path(path)
                await self.session.close()
                return resp

        loop = asyncio.get_event_loop()
        resp = loop.run_until_complete(downloader())
        return resp


    async def download_in_path(self, path):
        async with self.session.get(self.url) as resp:
            with open(path, 'wb') as fd:
                while True:
                    chunk = await resp.content.read(self.chunk_size)
                    if not chunk:
                        break
                    fd.write(chunk)
            return resp

    async def download_in_mem(self):
        data = b''
        async with self.session.get(self.url) as resp:
            while True:
                chunk = await resp.content.read(self.chunk_size)
                if not chunk:
                    break
                data += chunk
            return {'data': data, 'response': resp}
